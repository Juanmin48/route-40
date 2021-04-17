import 'package:flutter/material.dart';
import 'package:route_40/screens/route_details.dart';

void send(context, index, name, company, origin, destination, time) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => RDetails(
            index: index,
            name: name,
            company: company,
            origin: origin,
            destination: destination,
            time: time)),
  );
}

Widget route(context, index, name, company, origin, destination, time) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            send(context, index, name, company, origin, destination, time);
          },
          // send(context, index, name, company, origin, destination, time),
          child: Text(index,
              style: new TextStyle(
                  color: Color.fromRGBO(255, 154, 81, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0)),
        ),
        SizedBox(
          height: 15.0,
        ),
        GestureDetector(
            onTap: () {
              send(context, index, name, company, origin, destination, time);
            },
            child: Text(name,
                style: new TextStyle(color: Colors.white, fontSize: 19.0))),
        SizedBox(
          height: 8.0,
        ),
        GestureDetector(
          onTap: () {
            send(context, index, name, company, origin, destination, time);
          },
          child: Text(company,
              style: new TextStyle(color: Colors.white, fontSize: 19.0)),
        ),
        SizedBox(
          height: 8.0,
        ),
        GestureDetector(
          onTap: () {
            send(context, index, name, company, origin, destination, time);
          },
          child: Text("Tiempo de llegada: " + time,
              style: new TextStyle(color: Colors.white, fontSize: 19.0)),
        ),
        Divider(
          color: Color.fromRGBO(255, 154, 81, 1),
          height: 25,
        )
      ],
    ),
  );
}
