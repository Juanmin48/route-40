import 'package:flutter/material.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';
import 'package:route_40/widgets/textbox.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // padding: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.only(
              bottom: 16.0, top: 36.0, left: 16.0, right: 16.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromRGBO(38, 28, 20, 0.8),
              ),
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.centerLeft,
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Center(
                      child: Container(
                        child: Text("Inicio de sesión",
                            style: new TextStyle(
                              fontSize: 35.0,
                              color: Color.fromRGBO(255, 154, 81, 1),
                            )),
                      ),
                    ),
                    Spacer(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: GoogleAuthButton(
                              onPressed: () {},
                              darkMode: false,
                              style: AuthButtonStyle.icon,
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 5,
                            child: FacebookAuthButton(
                              onPressed: () {},
                              darkMode: false,
                              style: AuthButtonStyle.icon,
                            ),
                          ),
                        ]),
                    Spacer(),
                    email(),
                    SizedBox(
                      height: 38.0,
                    ),
                    password(),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.only(left: 180.0),
                      height: 50,
                      child: MaterialButton(
                        child: Text("Ingresar",
                            style: new TextStyle(
                              fontSize: 20.0,
                            )),
                        color: Color.fromRGBO(255, 154, 81, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                      ),
                    ),
                    Spacer(),
                  ])),
        ),
      ),
    );
  }
}
