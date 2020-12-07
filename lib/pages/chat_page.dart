import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textControler = TextEditingController();
  final _focusNode = FocusNode();
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  void dispose() {
    // TODO: off del socket
    _messages.forEach((message) => message.animationController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                'Te',
                style: TextStyle(fontSize: 13),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Melsia flores',
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
    print(texto);
    _textControler.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: '123',
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
  }
}
