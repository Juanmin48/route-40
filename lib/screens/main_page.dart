import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:route_40/screens/login.dart';
import 'package:route_40/screens/proutes.dart';
import 'package:route_40/screens/register.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  final User user;

  const Homepage({Key key, this.user}) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //Poner aqui las variables de estado y metodos
  GoogleMapController mapController;

  final LatLng _center = const LatLng(10.976778, -74.806306);
  LatLng _position = LatLng(10.976778, -74.806306);
  bool visibilitybuttons = true;

  final originController = TextEditingController();
  final destinationController = TextEditingController();
  List _routes = [];
  // _onPress() {
  //    setState(() {

  //    });
  // }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
    getRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
          onCameraMove: (CameraPosition position) {
            _position = position.target;
          },
        ),
        Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                                  MaterialPageRoute(
                                      builder: (context) => Login(
                                            iposition: _position,
                                          )),
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
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Register(iposition: _position)),
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
                          textbox(
                              destinationController, "Lugar de destino", false),
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () {
                                    buscar();
                                  }))
                        ])),
                  )
                ])),
      ],
    );
  }

  Future<http.Response> getRoute() async {
    if (originController.text != "" && destinationController.text != "") {
      String param = 'api/find/' +
          originController.text +
          ';' +
          destinationController.text;
      var response =
          await http.get(Uri.https('route40-server.herokuapp.com', param));
      if (response.statusCode == 200) {
        setState(() {
          _routes = jsonDecode(response.body);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PRoutes(
                    routes: _routes,
                    iposition: _position,
                    user: widget.user,
                  )),
        );
      }
      // print(_routes);
      return response;
    } else {
      return null;
    }
  }
}
