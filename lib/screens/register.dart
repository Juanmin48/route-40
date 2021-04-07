import 'package:flutter/material.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:route_40/screens/login.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Center(
                    child: Container(
                      child: Text("Registro",
                          style: new TextStyle(
                            fontSize: 35.0,
                            color: Color.fromRGBO(255, 154, 81, 1),
                          )),
                    ),
                  ),
                  Spacer(),
                  textbox(nameController, "Nombre"),
                  SizedBox(
                    height: 38.0,
                  ),
                  textbox(emailController, "Correo electrónico"),
                  SizedBox(
                    height: 38.0,
                  ),
                  textbox(passwordController, "Contraseña"),
                  SizedBox(
                    height: 38.0,
                  ),
                  textbox(conpasswordController, "Confirmar contraseña"),
                  Spacer(),
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
                      onPressed: () {},
                    ),
                  ),
                  Spacer(),
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
}
