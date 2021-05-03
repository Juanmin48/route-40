import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_40/model/data_model.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:route_40/screens/register.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DataModel>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    GoogleMapController mapController;
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Scaffold(
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
                      height: 38.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: GoogleAuthButton(
                              onPressed: () {
                                model.signInWithGoogle();
                                Navigator.of(context).pop();
                              },
                              darkMode: false,
                              style: AuthButtonStyle.icon,
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 58.0,
                    ),
                    textbox(emailController, "Correo electrónico", false),
                    SizedBox(
                      height: 38.0,
                    ),
                    textbox(passwordController, "Contraseña", true),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(model.errorMessage,
                          style: new TextStyle(
                            color: Color.fromRGBO(255, 154, 81, 1),
                          )),
                    ),
                    SizedBox(
                      height: 58.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 180.0),
                      height: 50,
                      child: MaterialButton(
                          child: Text("Ingresar",
                              style: new TextStyle(
                                fontSize: 20.0,
                              )),
                          color: Color.fromRGBO(255, 154, 81, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            model.signInFirebase(
                                emailController.text, passwordController.text);
                            Navigator.of(context).pop();
                          }),
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
                                  builder: (context) => Register()),
                            );
                          },
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
    );
  }
}
