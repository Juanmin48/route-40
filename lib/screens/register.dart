import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_40/model/data_model.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:route_40/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatelessWidget {
  const Register({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RegisterScreen();
  }
}

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DataModel>(context);
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final conpasswordController = TextEditingController();
    GoogleMapController mapController;
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    Future addUSer(User _user) async {
      model.users
          .add({
            'name': nameController.text,
            'email': emailController.text,
            'uid': _user.uid
          })
          .then((value) => print("Usuario añadido"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future register() async {
      try {
        if (passwordController.text == conpasswordController.text) {
          await model.auth
              .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text)
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
          model.setMessage = 'Este email ya existe.';
        } else if (e.code == 'weak-password') {
          model.setMessage = 'Contraseña muy debil';
        }
      }
    }

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: model.iposition,
            zoom: 13.0,
          ),
        ),
        Center(
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
                      textbox(
                          conpasswordController, "Confirmar contraseña", true),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(model.errorMessage,
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
                                MaterialPageRoute(
                                    builder: (context) => Login()),
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
        ),
      ],
    ));
  }
}
