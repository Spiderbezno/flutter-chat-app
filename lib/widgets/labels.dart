import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String mensaje;
  final String subMensaje;

  const Labels({
    Key key,
    @required this.ruta,
    @required this.mensaje,
    @required this.subMensaje,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            subMensaje,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(
              mensaje,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
