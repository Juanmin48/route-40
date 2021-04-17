import 'package:flutter/material.dart';
import 'package:route_40/screens/main_page.dart';
import 'package:route_40/widgets/route.dart';

class PRoutes extends StatefulWidget {
  final List routes;

  PRoutes(this.routes);

  @override
  _PRoutesState createState() => _PRoutesState();
}

class _PRoutesState extends State<PRoutes> {
  List _routes;
  List<Widget> routesC = new List<Widget>();

  @override
  void initState() {
    setState(() {
      _routes = widget.routes;
    });
    print(_routes);
    for (var i = 0; i < _routes.length; i++) {
      routesC.add(route(context, "Ruta N°" + i.toString(), _routes[i]['nameR'],
          _routes[i]['nameE'], "origen", "destino", "20"));
    }
    super.initState();
  }

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
                    child: ListView(
                        children: List.generate(
                            _routes.length,
                            (index) => route(
                                context,
                                "Ruta N°" + (index+1).toString(),
                                _routes[index]['nameR'],
                                _routes[index]['nameE'],
                                "origen",
                                "destino",
                                _routes[index]['time']))
                        ),
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
