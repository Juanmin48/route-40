import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/widgets/menu.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:route_40/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DataController dc = Get.find();

    GoogleMapController mapController;
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    Future addUSer(User _user) async {
      dc.users
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
          await dc.auth
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
          dc.errorMessage = 'Este email ya existe.';
        } else if (e.code == 'weak-password') {
          dc.errorMessage = 'Contraseña muy debil';
        }
      }
    }

    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: dc.iposition,
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
                        child: Text(dc.errorMessage,
                            style: new TextStyle(
                              color: Color.fromRGBO(255, 154, 81, 1),
                            )),
                      ),
                      //Spacer(),
                      SizedBox(
                        height: 28.0,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 25.0),
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
                          Container(
                            padding: const EdgeInsets.only(left: 50.0),
                            height: 50,
                            child: MaterialButton(
                                child: Text("Cancelar",
                                    style: new TextStyle(
                                      fontSize: 20.0,
                                    )),
                                color: Color.fromRGBO(255, 154, 81, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/', (Route<dynamic> route) => false);
                                }),
                          ),
                        ],
                      ),
                      //Spacer(),
                      SizedBox(
                        height: 38.0,
                      ),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              Get.toNamed('/login');
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
