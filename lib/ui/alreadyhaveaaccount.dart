import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  AlreadyHaveAnAccountCheck({
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return login ? Container():
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
           "Already have an Account ? ",
        ),
        GestureDetector(
          onTap: press ,
          child: Text(
            "Sign In",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    )
    ;
  }
}
