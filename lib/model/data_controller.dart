import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DataController extends GetxController {
  // Variables
  // GoogleMapController _mapController;
  final googleSignIn = GoogleSignIn();
  final firestoreInstance = FirebaseFirestore.instance;
  var _resultquery = [].obs;
  bool _isAuth = false;
  bool _isLogin = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  Rx<User> user = Rx<User>(null);
  var _url = "".obs;
  var _errorMessage = "".obs;
  Rx<String> msg = Rx<String>("");
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Rx<LatLng> _iposition = Rx<LatLng>(null);
  var _routes = [].obs;
  String messageE;

  void setRoutes(routes) {
    _routes.value = routes;
  }

  void setPosition(position) {
    _iposition.value = position;
  }

  void message(string) {
    messageE = string;
  }

  Future getdata() async {
    await firestoreInstance
        .collection("users")
        .where("uid", isEqualTo: user.value.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _resultquery = result.data()["fav"];
      });
    });
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
    users
        .where('uid', isEqualTo: user.value.uid)
        .get()
        .then((QuerySnapshot snapshot) => {
              if (snapshot.docs.length == 0)
                {
                  users
                      .add({
                        'name': user.value.displayName,
                        'email': user.value.email,
                        'uid': user.value.uid
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
    user.value = a.user;
    _url.value = user.value.photoURL;

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

    _isLogin = true;
    user.value = a.user;
    _url.value = user.value.photoURL + '?access_token=' + _token.token;
    addUSer();
  }

  Future _signOut() async {
    await _auth.signOut().then((value) => {
          _signOutGoogle(),
          _facebookLogin.logOut(),
          _isLogin = false,
        });
  }

  Future signInFirebase(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                _isLogin = true,
                _isAuth = true,
                user.value = value.user,
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage.value = 'Email/contraseña incorrectos';
      } else if (e.code == 'wrong-password') {
        _errorMessage.value = 'Email/contraseña incorrectos';
      }
    }
  }
}
