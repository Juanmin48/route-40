import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel extends ChangeNotifier {
  // Variables
  GoogleMapController _mapController;
  final googleSignIn = GoogleSignIn();
  final firestoreInstance = FirebaseFirestore.instance;
  dynamic _resultquery = [];
  bool _isAuth = false;
  bool _isLogin = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  User _user;
  String _url;
  String _errorMessage = "";
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  LatLng _iposition;
  List _routes;

  //Getters
  get resultquery => _resultquery;
  get user => _user;
  get errorMessage => _errorMessage;
  get users => _users;
  get url => _url;
  get iposition => _iposition;
  get mapController => _mapController;
  get auth => _auth;
  get routes => _routes;

  //Setters
  set setPosition(position) {
    _iposition = position;
    notifyListeners();
  }

  set setUser(user) {
    _user = user;
    notifyListeners();
  }

  set setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  set setRoutes(routes) {
    _routes = routes;
    notifyListeners();
  }

  void setMapController(controller) {
    _mapController = controller;
  }

  Future getdata() async {
    await firestoreInstance
        .collection("users")
        .where("uid", isEqualTo: _user.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _resultquery = result.data()["fav"];
      });
    });

    notifyListeners();
  }

  void _signOutGoogle() async {
    // sign out from google

    try {
      await googleSignIn.disconnect();
    } catch (error) {
      print(error);
    }

    notifyListeners();
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
    notifyListeners();
  }

  //Google login
  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var a = await _auth.signInWithCredential(credential);

    _isLogin = true;
    _user = a.user;
    _url = _user.photoURL;

    addUSer();
    notifyListeners();
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
    notifyListeners();
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _token = _result.accessToken;
    AuthCredential _credential = FacebookAuthProvider.credential(_token.token);
    var a = await _auth.signInWithCredential(_credential);

    _isLogin = true;
    _user = a.user;
    _url = _user.photoURL + '?access_token=' + _token.token;
    addUSer();
    notifyListeners();
  }

  Future _signOut() async {
    await _auth.signOut().then((value) => {
          _signOutGoogle(),
          _facebookLogin.logOut(),
          _isLogin = false,
        });
    notifyListeners();
  }

  Future signInFirebase(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                _isLogin = true,
                _isAuth = true,
                _user = value.user,
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = 'Email/contraseña incorrectos';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Email/contraseña incorrectos';
      }
    }
    notifyListeners();
  }
}
