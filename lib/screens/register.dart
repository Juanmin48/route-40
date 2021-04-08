import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:route_40/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controlador del input nombre
  final nameController = TextEditingController();
  // Controlador del input nombre de usuario
  final usernameController = TextEditingController();
  // Controlador del input email
  final emailController = TextEditingController();
  // Controlador del input contraseña
  final passwordController = TextEditingController();
  // Controlador del input condirmar contraseña
  final conpasswordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = "";
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
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
            child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Spacer(),
                  SizedBox(
                    height: 38.0,
                  ),
                  Center(
                    child: Container(
                      child: Text("Registro",
                          style: new TextStyle(
                            fontSize: 35.0,
                            color: Color.fromRGBO(255, 154, 81, 1),
                          )),
                    ),
                  ),
                  //Spacer(),
                  SizedBox(
                    height: 58.0,
                  ),
                  textbox(nameController, "Nombre", false),
                  SizedBox(
                    height: 38.0,
                  ),
                  textbox(emailController, "Correo electrónico", false),
                  SizedBox(
                    height: 38.0,
                  ),
                  textbox(passwordController, "Contraseña", true),
                  SizedBox(
                    height: 38.0,
                  ),
                  textbox(conpasswordController, "Confirmar contraseña", true),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(_errorMessage,
                        style: new TextStyle(
                          color: Color.fromRGBO(255, 154, 81, 1),
                        )),
                  ),
                  //Spacer(),
                  SizedBox(
                    height: 38.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 180.0),
                    height: 50,
                    child: MaterialButton(
                      child: Text("Registrar",
                          style: new TextStyle(
                            fontSize: 20.0,
                          )),
                      color: Color.fromRGBO(255, 154, 81, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () async {
                        await register();
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
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          "¿Ya tienes cuenta? Inicia sesión",
                          style: TextStyle(
                            color: Color.fromRGBO(255, 154, 81, 1),
                          ),
                        )),
                  )
                ])),
      ),
    ));
  }

  Future addUSer(User _user) async {
    _users
        .add(
            {'name': nameController.text, 'email': emailController.text, 'uid': _user.uid})
        .then((value) => print("Usuario añadido"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future register() async {
    try {
      if (passwordController.text == conpasswordController.text) {
        await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) => {
                  addUSer(value.user),
                  print(nameController
                      .text), // ASI OBTIENES EL NOMBRE DEL USUARIO.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  )
                });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errorMessage = 'Este email ya existe.';
        setState(() {});
      } else if (e.code == 'weak-password') {
        _errorMessage = 'Contraseña muy debil';
        setState(() {});
      }
    }
  }
}
