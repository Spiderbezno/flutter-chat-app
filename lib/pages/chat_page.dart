import 'package:chat/models/mensaje.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textControler = TextEditingController();
  final _focusNode = FocusNode();
  ChatService _chatService;
  SocketService _socketService;
  AuthService _authService;
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  void initState() {
    _chatService = Provider.of<ChatService>(context, listen: false);
    _socketService = Provider.of<SocketService>(context, listen: false);
    _authService = Provider.of<AuthService>(context, listen: false);

    _socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(_chatService.usurioPara.uid);
    super.initState();
  }

  void _cargarHistorial(String uid) async {
    List<Mensaje> chat = await _chatService.getChat(uid);
    final history = chat.map(
      (m) => ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward(),
      ),
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
      message.animationController.forward();
    });
  }

  @override
  void dispose() {
    _socketService.socket.off('mensaje-personal');
    _messages.forEach((message) => message.animationController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usurioPara = _chatService.usurioPara;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                usurioPara.nombre.substring(0, 2),
                style: TextStyle(fontSize: 13),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              usurioPara.nombre,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
                reverse: true,
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textControler,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  if (text.isNotEmpty) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                  setState(() {});
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: IconTheme(
                    data: IconThemeData(color: Colors.blue[400]),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _estaEscribiendo ? () => _handleSubmit(_textControler.text.trim()) : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    _textControler.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: _authService.usuario.uid,
      texto: texto,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
    _socketService.emit('mensaje-personal', {
      'de': _authService.usuario.uid,
      'para': _chatService.usurioPara.uid,
      'mensaje': texto,
    });
  }
}
