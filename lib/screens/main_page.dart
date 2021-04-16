import 'package:flutter/material.dart';
import 'package:route_40/screens/login.dart';
import 'package:route_40/screens/proutes.dart';
import 'package:route_40/screens/register.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //Poner aqui las variables de estado y metodos

  bool visibilitybuttons = true;

  final originController = TextEditingController();
  final destinationController = TextEditingController();
  // _onPress() {
  //    setState(() {

  //    });
  // }
  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          visibilitybuttons = !visible;
        });
      },
    );
  }

  void buscar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PRoutes()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          visibilitybuttons
              ? Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 120.0, left: 20.0, right: 20.0),
                    child: MaterialButton(
                      child: Text("Iniciar sesión",
                          style: new TextStyle(
                            fontSize: 20.0,
                          )),
                      color: Color.fromRGBO(255, 154, 81, 1),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                    ),
                  ))
              : Container(),
          SizedBox(
            height: 58.0,
          ),
          visibilitybuttons
              ? Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 120.0, left: 20.0, right: 20.0),
                    child: MaterialButton(
                      child: Text("Registro",
                          style: new TextStyle(
                            fontSize: 20.0,
                          )),
                      color: Color.fromRGBO(255, 154, 81, 1),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                    ),
                  ),
                )
              : Container(),
          Expanded(
            flex: 3,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color.fromRGBO(38, 28, 20, 0.8),
                ),
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.centerLeft,
                child: ListView(children: [
                  textbox(originController, "Lugar de origen", false),
                  SizedBox(
                    height: 48.0,
                  ),
                  textbox(destinationController, "Lugar de destino", false),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 180.0),
                      height: 50,
                      child: MaterialButton(
                          child: Text("Buscar",
                              style: new TextStyle(
                                fontSize: 20.0,
                              )),
                          color: Color.fromRGBO(255, 154, 81, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            buscar();
                          }))
                ])),
          )
        ]));
  }
}
