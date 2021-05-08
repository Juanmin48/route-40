import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/screens/route_details.dart';

void send(route) {
  Get.to(() => RDetails(), arguments: route);
}

Widget route(index, name, company, origin, destination, time, route) {
  return MaterialButton(
    onPressed: () => send(route),
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(index,
              style: new TextStyle(
                  color: Color.fromRGBO(255, 154, 81, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0)),
          SizedBox(
            height: 15.0,
          ),
          Text(name, style: new TextStyle(color: Colors.white, fontSize: 19.0)),
          SizedBox(
            height: 8.0,
          ),
          Text(company,
              style: new TextStyle(color: Colors.white, fontSize: 19.0)),
          SizedBox(
            height: 8.0,
          ),
          Text("Tiempo de llegada: " + time,
              style: new TextStyle(color: Colors.white, fontSize: 19.0)),
          Divider(
            color: Color.fromRGBO(255, 154, 81, 1),
            height: 25,
          )
        ],
      ),
    ),
  );
}
