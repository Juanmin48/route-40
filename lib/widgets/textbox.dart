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

Widget email(emailController) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    child: TextField(
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          fillColor: Colors.white,
          hintText: "Correo electrónico:",
          hintStyle: TextStyle(color: Colors.grey)),
    ),
  );
}

Widget password(passwordController) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    child: TextField(
      controller: passwordController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          fillColor: Colors.white,
          hintText: "Contraseña:",
          hintStyle: TextStyle(color: Colors.grey)),
    ),
  );
}
