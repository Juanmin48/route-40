import 'package:flutter/material.dart';

// Widget _emailInput(Icon tbicon, String tbhint, String tblabel tbvalidator) {
Widget textInput() {
  return TextFormField(
    decoration: const InputDecoration(
      icon: Icon(Icons.email),
      // hintText: tbhint,
      labelText: "Email",
    ),
    //validator: (value) => tbvalidator
  );
}

Widget passwordInput() {
  return TextFormField(
    decoration: const InputDecoration(
      icon: Icon(Icons.lock),
      // hintText: 'Inserte su contraseña',
      labelText: 'Contraseña',
    ),
    // validator: (value) => _validatorPassword(value)
  );
}

Widget textbox(controller, message) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          fillColor: Colors.white,
          hintText: message,
          hintStyle: TextStyle(color: Colors.grey)),
    ),
  );
}
