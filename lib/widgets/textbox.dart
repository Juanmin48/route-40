import 'package:flutter/material.dart';

Widget textbox(controller, message, cont) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    child: TextField(
      obscureText: cont,
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          fillColor: Colors.white,
          hintText: message,
          hintStyle: TextStyle(color: Colors.grey)),
    ),
  );
}
