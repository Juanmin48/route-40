import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DataController extends GetxController {
  // Variables

  final googleSignIn = GoogleSignIn();
  final firestoreInstance = FirebaseFirestore.instance;
  dynamic resultquery = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  String url;
  String errorMessage = "";
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  LatLng iposition = const LatLng(10.976778, -74.806306);
  List routes;

  void setMessage(message) {
    errorMessage = message;
  }

  Future setRoutes(proutes) async {
    routes = proutes;
  }

  void setPosition(position) {
    iposition = position;
  }

  Future getdata() async {
    await firestoreInstance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        resultquery = result.data();
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
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot snapshot) => {
              if (snapshot.docs.length == 0)
                {
                  users
                      .add({
                        'name': user.displayName,
                        'email': user.email,
                        'uid': user.uid
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

    var a = await auth.signInWithCredential(credential);

    user = a.user;
    url = user.photoURL;

    // print(user);
    addUSer();
  }

  Future signOut() async {
    await auth.signOut().then((value) => {
          _signOutGoogle(),
        });
  }

  Future signInFirebase(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                user = value.user,
                getdata(),
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'Email/contraseña incorrectos';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Email/contraseña incorrectos';
      }
    }
  }
}
