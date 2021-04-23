import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_40/screens/login.dart';
import 'package:route_40/widgets/route.dart';

class FRoutes extends StatefulWidget {
  final LatLng iposition;
  final dynamic result;
  final User user;
  const FRoutes({Key key, @required this.iposition, this.user, this.result})
      : super(key: key);

  @override
  _FRoutesState createState() => _FRoutesState();
}

class _FRoutesState extends State<FRoutes> {
  List<dynamic> _routes;
  //Controlador del mapa
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    setState(() {
      _routes = widget.result;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.iposition,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 40.0,
                      ),
                      Center(
                        child: Container(
                          child: Text("Rutas favoritas",
                              style: new TextStyle(
                                fontSize: 35.0,
                                color: Color.fromRGBO(255, 154, 81, 1),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      if (widget.result != null)
                        Expanded(
                            child: ListView(
                                children: List.generate(
                                    _routes.length,
                                    (index) => route(
                                        context,
                                        "Ruta N°" + (index + 1).toString(),
                                        _routes[index]['compañia'],
                                        _routes[index]['ruta'],
                                        "Origen: ${_routes[index]['pointInit']}",
                                        "Destino: ${_routes[index]['pointFinal']}",
                                        _routes[index]['tiempo'],
                                        _routes[index],
                                        widget
                                            .user))) //         widget.user))),
                            ),
                      Center(
                        child: Container(
                            padding:
                                const EdgeInsets.only(left: 90.0, right: 90.0),
                            height: 50,
                            child: MaterialButton(
                              child: Text("Atrás",
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  )),
                              color: Color.fromRGBO(255, 154, 81, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login(
                                            iposition: widget.iposition,
                                          )),
                                );
                              },
                            )),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
