import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Login extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DataController dc = Get.find();

    GoogleMapController mapController;
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    Future login() async {
      if (emailController.text != "" && passwordController.text != "") {
        await dc.signInFirebase(emailController.text, passwordController.text);
        if (dc.errorMessage == "") {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        } else {
          dc.showAlertDialog(context, 'Error', dc.errorMessage);
        }
      } else {
        dc.showAlertDialog(context, 'Error', "Debe rellenar todos los campos");
      }
    }

    return GestureDetector(
        key: Key('loginG'),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
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
                          height: 58.0,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: GoogleAuthButton(
                                  onPressed: () async {
                                    await dc.signInWithGoogle();
                                    Navigator.of(context).pop(true);
                                  },
                                  darkMode: false,
                                  style: AuthButtonStyle.icon,
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 58.0,
                        ),
                        textbox(emailController, "Correo electrónico", false,
                            'emailL'),
                        SizedBox(
                          height: 38.0,
                        ),
                        textbox(passwordController, "Contraseña", true,
                            'passwordL'),
                        // Container(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: Text(dc.errorMessage,
                        //       style: new TextStyle(
                        //         color: Color.fromRGBO(255, 154, 81, 1),
                        //       )),
                        // ),
                        SizedBox(
                          height: 38.0,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              height: 50,
                              child: MaterialButton(
                                  child: Text("Ingresar",
                                      style: new TextStyle(
                                        fontSize: 20.0,
                                      )),
                                  color: Color.fromRGBO(255, 154, 81, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () {
                                    login();
                                  }),
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/',
                                            (Route<dynamic> route) => false);
                                  }),
                            ),
                          ],
                        ),
                        //Spacer(),
                        SizedBox(
                          height: 58.0,
                        ),
                        Container(
                          child: TextButton(
                              onPressed: () => Get.toNamed('/register'),
                              child: Text(
                                "¿No tienes cuenta? Registrate",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 154, 81, 1),
                                ),
                              )),
                        )
                      ])),
                ),
              ),
            ],
          ),
        ));
  }
}
