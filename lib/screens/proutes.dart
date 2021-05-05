import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/model/data_model.dart';
import 'package:route_40/screens/main_page.dart';
import 'package:route_40/widgets/route.dart';

class PRoutes extends StatelessWidget {
  const PRoutes({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PRoutesScreen();
  }
}

class PRoutesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DataModel>(context);
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
                                model.routes.length,
                                (index) => route(
                                    context,
                                    "Ruta N°" + (index + 1).toString(),
                                    model.routes[index]['nameR'],
                                    model.routes[index]['nameE'],
                                    "Origen: ${model.routes[index]['pointInit']}",
                                    "Destino: ${model.routes[index]['pointFinal']}",
                                    model.routes[index]['time'],
                                    model.routes[index],
                                    model.user))),
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
                                Navigator.of(context).pop();
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
