import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController mapController;
  DataController dc = Get.find();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool _visiblebuttons = true;
  final LatLng _center = const LatLng(10.976778, -74.806306);
  final originController = TextEditingController();
  final destinationController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _visiblebuttons = !visible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<http.Response> getRoute() async {
      if (originController.text != "" && destinationController.text != "") {
        String param = 'api/find/' +
            originController.text +
            ';' +
            destinationController.text;
        var response =
            await http.get(Uri.https('route40-server.herokuapp.com', param));
        if (response.statusCode == 200) {
          var r = jsonDecode(response.body);
          if (r.length > 0) {
            dc.routes = r;
            Get.toNamed('/proutes');
          } else {
            dc.showAlertDialog(context, "Alerta", "No se han encontrado rutas");
          }
        }
        return response;
      } else {
        dc.showAlertDialog(context, "Error", "Debe rellenar todos los campos");
        return null;
      }
    }

    void buscar() {
      dc.goback = false;
      getRoute();
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
          onCameraMove: (CameraPosition position) {
            dc.iposition = position.target;
          },
        ),
        Container(
            padding: const EdgeInsets.only(
                bottom: 16.0, top: 36.0, left: 16.0, right: 16.0),
            alignment: Alignment.centerLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _visiblebuttons
                      ? Container(
                          padding:
                              EdgeInsets.only(right: 297, top: 5, bottom: 355),
                          alignment: Alignment.center,
                          child: MaterialButton(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Icon(
                                Icons.menu,
                                size: 32,
                              ),
                            ),
                            color: Color.fromRGBO(255, 154, 81, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
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
                          textbox(originController, "Lugar de origen", false,
                              'origin'),
                          SizedBox(
                            height: 48.0,
                          ),
                          textbox(destinationController, "Lugar de destino",
                              false, 'destination'),
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
}
