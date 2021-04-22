import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:route_40/screens/main_page.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:route_40/screens/register.dart';
import 'package:route_40/screens/fav_routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Login extends StatefulWidget {
  final LatLng iposition;

  const Login({Key key, @required this.iposition}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Controlador del input email
  final emailController = TextEditingController();
  final googleSignIn = GoogleSignIn();

  /// Controlador del input pass
  final passwordController = TextEditingController();
  //Controlador del mapa
  GoogleMapController mapController;
  final LatLng _center = const LatLng(11.018843, -74.850514);
  // final LatLng _center = widget.coords;
  bool _isAuth = false;
  bool _isLogin = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  User _user;
  String _url;
  String _errorMessage = "";
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.iposition,
              zoom: 13.0,
            ),
          ),
          !_isLogin
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 16.0, top: 36.0, left: 16.0, right: 16.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color.fromRGBO(38, 28, 20, 0.8),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        alignment: Alignment.centerLeft,
                        child: ListView(children: [
                          SizedBox(
                            height: 58.0,
                          ),
                          Center(
                            child: Container(
                              child: Text("Inicio de sesión",
                                  style: new TextStyle(
                                    fontSize: 35.0,
                                    color: Color.fromRGBO(255, 154, 81, 1),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 38.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: GoogleAuthButton(
                                    onPressed: () {
                                      _signInWithGoogle();
                                    },
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
                          SizedBox(
                            height: 58.0,
                          ),
                          textbox(emailController, "Correo electrónico", false),
                          SizedBox(
                            height: 38.0,
                          ),
                          textbox(passwordController, "Contraseña", true),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(_errorMessage,
                                style: new TextStyle(
                                  color: Color.fromRGBO(255, 154, 81, 1),
                                )),
                          ),
                          SizedBox(
                            height: 58.0,
                          ),
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
                                try {
                                  await _auth
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
                                    _errorMessage =
                                        'Email/contraseña incorrectos';
                                    setState(() {});
                                  } else if (e.code == 'wrong-password') {
                                    _errorMessage =
                                        'Email/contraseña incorrectos';
                                    setState(() {});
                                  }
                                }
                              },
                            ),
                          ),
                          //Spacer(),
                          SizedBox(
                            height: 58.0,
                          ),
                          Container(
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register(
                                            iposition: widget.iposition)),
                                  );
                                },
                                child: Text(
                                  "¿No tienes cuenta? Registrate",
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 154, 81, 1),
                                  ),
                                )),
                          )
                        ])),
                  ),
                )
              : Center(
                  child: !_isAuth
                      ? Container(
                          padding: const EdgeInsets.only(
                              bottom: 16.0, top: 36.0, left: 16.0, right: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromRGBO(38, 28, 20, 0.8),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage: NetworkImage(_url),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    _user.displayName,
                                    style: TextStyle(
                                        fontSize: 30.0, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 90.0, right: 90.0),
                                        height: 50,
                                        child: MaterialButton(
                                          child: Text("Rutas favoritas",
                                              style: new TextStyle(
                                                fontSize: 20.0,
                                              )),
                                          color:
                                              Color.fromRGBO(255, 154, 81, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => FRoutes(
                                                        iposition:
                                                            widget.iposition,
                                                      )),
                                            );
                                          },
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      await _signOut();
                                    },
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    color: Color.fromRGBO(255, 154, 81, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homepage(
                                                  user: _user,
                                                )),
                                      );
                                    },
                                    child: Text(
                                      "Atrás",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    color: Color.fromRGBO(255, 154, 81, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                ]),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.only(
                              bottom: 16.0, top: 36.0, left: 16.0, right: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromRGBO(38, 28, 20, 0.8),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_user.email,
                                      style: TextStyle(
                                          fontSize: 30.0, color: Colors.white)),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 90.0, right: 90.0),
                                        height: 50,
                                        child: MaterialButton(
                                          child: Text("Rutas favoritas",
                                              style: new TextStyle(
                                                fontSize: 20.0,
                                              )),
                                          color:
                                              Color.fromRGBO(255, 154, 81, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => FRoutes(
                                                        iposition:
                                                            widget.iposition,
                                                      )),
                                            );
                                          },
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      await _signOut();
                                    },
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    color: Color.fromRGBO(255, 154, 81, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homepage(
                                                  user: _user,
                                                )),
                                      );
                                    },
                                    child: Text(
                                      "Atrás",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    color: Color.fromRGBO(255, 154, 81, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                ]),
                          ),
                        )),
        ],
      ),
    );
  }

  void _signOutGoogle() async {
    // sign out from google

    try {
      await googleSignIn.disconnect();
    } catch (error) {
      print(error);
    }
  }

  Future addUSer() async {
    _users
        .where('uid', isEqualTo: _user.uid)
        .get()
        .then((QuerySnapshot snapshot) => {
              if (snapshot.docs.length == 0)
                {
                  _users
                      .add({
                        'name': _user.displayName,
                        'email': _user.email,
                        'uid': _user.uid
                      })
                      .then((value) => print("Usuario añadido"))
                      .catchError(
                          (error) => print("Failed to add user: $error"))
                }
              else
                {print('Usuario ya registrado')}
            });
  }

  //Google login
  Future _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var a = await _auth.signInWithCredential(credential);
    setState(() {
      _isLogin = true;
      _user = a.user;
      _url = _user.photoURL;
    });
    addUSer();
  }

  //Facebook login
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
    addUSer();
  }

  Future _signOut() async {
    await _auth.signOut().then((value) => {
          setState(() {
            _signOutGoogle();
            _facebookLogin.logOut();
            _isLogin = false;
          })
        });
  }
}
