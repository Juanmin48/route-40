import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:route_40/screens/login.dart';

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

    Future register() async {
      if (emailController.text != "" &&
          passwordController.text != "" &&
          conpasswordController.text != "" &&
          nameController.text != "") {
        await dc.register(emailController.text, passwordController.text,
            conpasswordController.text, nameController.text);
        if (dc.errorMessage == "") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        } else {
          dc.showAlertDialog(context, 'Error', dc.errorMessage);
        }
      } else {
        dc.showAlertDialog(context, 'Error', "Debe rellenar todos los campos");
      }
    }

    return GestureDetector(
        key: Key('registerG'),
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
                          textbox(nameController, "Nombre", false, 'nameR'),
                          SizedBox(
                            height: 38.0,
                          ),
                          textbox(emailController, "Correo electrónico", false,
                              'emailR'),
                          SizedBox(
                            height: 38.0,
                          ),
                          textbox(passwordController, "Contraseña", true,
                              'passwordR'),
                          SizedBox(
                            height: 38.0,
                          ),
                          textbox(conpasswordController, "Confirmar contraseña",
                              true, 'confirmationPass'),
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () async {
                                    register();
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
        )));
  }
}
