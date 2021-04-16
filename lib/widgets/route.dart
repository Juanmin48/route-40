import 'package:flutter/material.dart';

Widget route(name, address, company, time) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 10.0,
        ),
        Text(name,
            style: new TextStyle(
                color: Color.fromRGBO(255, 154, 81, 1),
                fontWeight: FontWeight.bold,
                fontSize: 25.0)),
        SizedBox(
          height: 15.0,
        ),
        Text(address,
            style: new TextStyle(color: Colors.white, fontSize: 19.0)),
        SizedBox(
          height: 8.0,
        ),
        Text(company,
            style: new TextStyle(color: Colors.white, fontSize: 19.0)),
        SizedBox(
          height: 8.0,
        ),
        Text("Tiempo de llegada: " + time + " minutos",
            style: new TextStyle(color: Colors.white, fontSize: 19.0)),
        Divider(
          color: Color.fromRGBO(255, 154, 81, 1),
          height: 25,
        )
      ],
    ),
  );
}
