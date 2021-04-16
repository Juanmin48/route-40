import 'package:flutter/material.dart';
import 'package:route_40/screens/main_page.dart';
import 'package:route_40/widgets/route.dart';

class PRoutes extends StatefulWidget {
  @override
  _PRoutesState createState() => _PRoutesState();
}

class _PRoutesState extends State<PRoutes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                    child: ListView(children: [
                      //Ejemplo de ruta (reemplazar parametros)
                      route(context, "Ruta N°1", "Carrera 38", "Sobusa",
                          "origen", "destino", "30"),
                      route(context, "Ruta N°2", "Calle 72", "Sodis", "origen",
                          "destino", "20")
                    ]),
                  ),
                  Center(
                    child: Container(
                        padding: const EdgeInsets.only(left: 90.0, right: 90.0),
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
                                  builder: (context) => Homepage()),
                            );
                          },
                        )),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
