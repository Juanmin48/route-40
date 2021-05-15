import 'package:flutter/material.dart';

Widget userData(label, data) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.0,
        ),
        Text(label,
            style: new TextStyle(
                color: Color.fromRGBO(255, 154, 81, 1),
                fontWeight: FontWeight.bold,
                fontSize: 25.0)),
        SizedBox(
          height: 15.0,
        ),
        Text(data, style: new TextStyle(color: Colors.white, fontSize: 19.0)),
        SizedBox(
          height: 8.0,
        ),
        Divider(
          color: Color.fromRGBO(255, 154, 81, 1),
          height: 25,
        )
      ],
    ),
  );
}
