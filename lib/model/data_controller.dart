import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool loginGoogle = false;
  bool goback;

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

  showAlertDialog(BuildContext context, String title, String message) {
    // Create button
    Widget okButton = TextButton(
      child: Text("Cerrar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
    loginGoogle = true;
    // print(user);
    addUSer();
    getdata();
  }

  Future signOut() async {
    await auth.signOut().then((value) => {
          if (loginGoogle) {_signOutGoogle(), loginGoogle = false},
          user = null,
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

  Future register(
      String email, String password, String conpassword, String name) async {
    try {
      if (password == conpassword) {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  user = value.user,
                  addUSer(),
                  print(name), // ASI OBTIENES EL NOMBRE DEL USUARIO.
                });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Este email ya existe.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Contraseña muy debil';
      }
    }
  }
}
