import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';
import 'package:route_40/widgets/textbox.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Controlador del input email
  final emailController = TextEditingController();

  /// Controlador del input pass
  final passwordController = TextEditingController();
  bool _isAuth = false;
  bool _isLogin = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  User _user;
  String _url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLogin
          ? Center(
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
                                    onPressed: () async {
                                      await _handleLogin();
                                    },
                                    darkMode: false,
                                    style: AuthButtonStyle.icon,
                                  ),
                                ),
                              ]),
                          Spacer(),
                          email(emailController),
                          SizedBox(
                            height: 38.0,
                          ),
                          password(passwordController),
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
                              onPressed: () async {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => Login()),
                                // );
                                try {
                                  _auth
                                      .signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((value) => {
                                            setState(() {
                                              _isLogin = true;
                                              _isAuth = true;
                                              _user = value.user;
                                            })
                                          });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    print(
                                        'Wrong password provided for that user.');
                                  }
                                }
                              },
                            ),
                          ),
                          Spacer(),
                        ])),
              ),
            )
          : Center(
              child: !_isAuth
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          CircleAvatar(
                            radius: 40.0,
                            backgroundImage: NetworkImage(_url),
                          ),
                          Text(
                            _user.displayName,
                            style: TextStyle(fontSize: 30.0),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          OutlineButton(
                            onPressed: () async {
                              await _signOut();
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ])
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          CircleAvatar(
                            radius: 40.0,
                            //backgroundImage: NetworkImage(_url),
                          ),
                          Text(
                            _user.email,
                            style: TextStyle(fontSize: 30.0),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          OutlineButton(
                            onPressed: () async {
                              await _signOut();
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ])),
    );
  }

  Future _handleLogin() async {
    FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
    switch (_result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("cancelled by user");
        break;

      case FacebookLoginStatus.error:
        print("error");
        break;

      case FacebookLoginStatus.loggedIn:
        await _loginWithFacebook(_result);
        break;
      default:
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _token = _result.accessToken;
    AuthCredential _credential = FacebookAuthProvider.credential(_token.token);
    var a = await _auth.signInWithCredential(_credential);
    setState(() {
      _isLogin = true;
      _user = a.user;
      _url = _user.photoURL + '?access_token=' + _token.token;
    });
  }

  Future _signOut() async {
    await _auth.signOut().then((value) => {
          setState(() {
            _facebookLogin.logOut();
            _isLogin = false;
          })
        });
  }
}
