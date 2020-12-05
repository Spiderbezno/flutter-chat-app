import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final TextInputType type;
  final String hintText;
  final TextEditingController texController;
  final bool isPassword;

  const CustomInput({
    Key key,
    this.type = TextInputType.text,
    @required this.icon,
    @required this.hintText,
    @required this.texController,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: texController,
        autocorrect: false,
        obscureText: isPassword,
        keyboardType: type,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.hintText,
        ),
      ),
    );
  }
}
