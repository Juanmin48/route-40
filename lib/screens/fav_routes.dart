import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/screens/login.dart';
import 'package:route_40/widgets/route.dart';

class FRoutes extends StatelessWidget {
  const FRoutes({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FRoutesScreen();
  }
}

class FRoutesScreen extends StatelessWidget {
  //Controlador del mapa
  @override
  Widget build(BuildContext context) {
    DataController dc = Get.find();
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
                      if (dc.routes != null)
                        Expanded(
                            child: ListView(
                                children: List.generate(
                                    dc.routes.length,
                                    (index) => route(
                                        context,
                                        "Ruta N°" + (index + 1).toString(),
                                        dc.routes[index]['nameE'],
                                        dc.routes[index]['nameR'],
                                        "Origen: ${dc.routes[index]['pointInit']}",
                                        "Destino: ${dc.routes[index]['pointFinal']}",
                                        dc.routes[index]['time'],
                                        dc.routes[index],
                                        dc.user))) //         widget.user))),
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
                                      builder: (context) => Login()),
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
