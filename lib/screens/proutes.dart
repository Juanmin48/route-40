import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/widgets/menu.dart';
import 'package:route_40/widgets/route.dart';

class PRoutes extends StatelessWidget {
  static final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DataController dc = Get.find();
    GoogleMapController mapController;

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Scaffold(
      key: globalKey,
      drawer: Menu(),
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
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 297, bottom: 10),
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
                        globalKey.currentState.openDrawer();
                      },
                    ),
                  ),
                  Expanded(
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
                                child: Text("Posibles rutas",
                                    style: new TextStyle(
                                      fontSize: 35.0,
                                      color: Color.fromRGBO(255, 154, 81, 1),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Expanded(
                              child: ListView(
                                  children: List.generate(
                                      dc.routes.length,
                                      (index) => route(
                                            "Ruta N°" + (index + 1).toString(),
                                            dc.routes[index]['nameR'],
                                            dc.routes[index]['nameE'],
                                            "Origen: ${dc.routes[index]['pointInit']}",
                                            "Destino: ${dc.routes[index]['pointFinal']}",
                                            dc.routes[index]['time'],
                                            dc.routes[index],
                                          ))),
                            ),
                            Center(
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 90.0, right: 90.0),
                                  height: 50,
                                  child: MaterialButton(
                                    child: Text("Atrás",
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
                                    },
                                  )),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
