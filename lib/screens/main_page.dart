import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/widgets/textbox.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController mapController;
  DataController dc = Get.find();
  bool _visiblebuttons = true;
  final LatLng _center = const LatLng(10.976778, -74.806306);
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final _focusOrigin = FocusNode();
  final _focusDestination = FocusNode();
  LocationData currentLocation;
  Location location;
  bool _orFocus = false, _destFocus = false;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    dc.setCustomIcon();
    location = new Location();

    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
    });
    setInitialLocation();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _visiblebuttons = !visible;
        });
        if (!visible) {
          setState(() {
            _orFocus = false;
            _destFocus = false;
          });
        }
      },
    );
    _focusOrigin.addListener(() {
      setState(() {
        _orFocus = true;
        _destFocus = false;
      });
    });
    _focusDestination.addListener(() {
      setState(() {
        _destFocus = true;
        _orFocus = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void startRoute() {
      for (var route in dc.routes) {
        String param = '/api/busLocation/' +
            route['nameE'] +
            ';' +
            route['nameR'] +
            ';' +
            route['pointInit']['_latitude'].toString() +
            ':' +
            route['pointInit']['_longitude'].toString();
        http.get(Uri.https('route40-server.herokuapp.com', param));
        // print(route['pointInit']);
      }
    }

    Future<http.Response> getRoute() async {
      if (originController.text != "" && destinationController.text != "") {
        List<geocoding.Location> origin = await geocoding
            .locationFromAddress("${originController.text}, Barranquilla");
        List<geocoding.Location> destination = await geocoding
            .locationFromAddress("${destinationController.text}, Barranquilla");
        String coordsOr = origin[0].latitude.toString() +
            ',' +
            origin[0].longitude.toString();
        String coordsDes = destination[0].latitude.toString() +
            ',' +
            destination[0].longitude.toString();
        String param = '/api/find/' + coordsOr + ';' + coordsDes;
        var response =
            await http.get(Uri.https('route40-server.herokuapp.com', param));
        if (response.statusCode == 200) {
          var r = jsonDecode(response.body);
          if (r.length > 0) {
            dc.routes = r;
            startRoute();
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

    void useLocation() async {
      List<geocoding.Placemark> ubicacionA =
          await geocoding.placemarkFromCoordinates(
              currentLocation.latitude, currentLocation.longitude);
      originController.text = ubicacionA[0].street;
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          compassEnabled: true,
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
                          !_destFocus
                              ? textbox(originController, "Lugar de origen",
                                  false, 'origin', _focusOrigin)
                              : Container(),
                          _orFocus
                              ? SizedBox(
                                  height: 10.0,
                                )
                              : Container(),
                          _orFocus
                              ? TextButton(
                                  onPressed: () => useLocation(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.pin_drop_outlined,
                                          color: Colors.white),
                                      SizedBox(width: 5),
                                      Text(
                                        "Usar ubicación actual",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ))
                              : Container(),
                          !_destFocus
                              ? SizedBox(
                                  height: 48.0,
                                )
                              : Container(),
                          !_orFocus
                              ? textbox(
                                  destinationController,
                                  "Lugar de destino",
                                  false,
                                  'destination',
                                  _focusDestination)
                              : Container(),
                          SizedBox(
                            height: 30.0,
                          ),
                          (!_orFocus && !_destFocus)
                              ? Container(
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
                              : Container()
                        ])),
                  )
                ])),
      ],
    );
  }
}
