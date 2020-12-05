import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;

  const BotonAzul({
    Key key,
    this.color = Colors.blue,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: this.color,
      shape: StadiumBorder(),
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
      onPressed: this.onPressed,
    );
  }
}
