import 'package:flutter/material.dart';
import 'package:route_40/screens/login.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //Poner aqui las variables de estado y metodos

  // _onPress() {
  //    setState(() {

  //    });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(
                bottom: 320.0, top: 320.0, left: 20.0, right: 20.0),
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
        ]));
  }
}
