import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  var _url = 'spadessoftware@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Image.asset('assets/logo.jpg'),
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "Facing Issues?",
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                RichText(
                  textScaleFactor: 1.2,
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Send your queries at: ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                        text: "query@spadessoftware.com",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {

                          }),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
