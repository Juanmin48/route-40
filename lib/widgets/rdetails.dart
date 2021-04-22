import 'package:flutter/material.dart';

void funcion(user, fav) {
  //Agregar aqui codigo para agregar o eliminar ruta de los favoritos de @user dependiendo del booleano @fav
}
Widget rdetails(index, name, company, origin, destination, time, user, fav) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: 8,
              child: Center(
                child: Text(index,
                    style: new TextStyle(
                        color: Color.fromRGBO(255, 154, 81, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
              ),
            ),
            if (user != null)
              Expanded(
                  flex: 1,
                  child: MaterialButton(
                      onPressed: () => funcion(user, fav),
                      child: !fav
                          ? Icon(
                              Icons.star_border,
                              size: 30,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.star,
                              size: 30,
                              color: Color.fromRGBO(255, 154, 81, 1),
                            )))
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Row(
          children: [
            Text(company,
                style: new TextStyle(color: Colors.white, fontSize: 19.0)),
            SizedBox(
              width: 10.0,
            ),
            Text("-",
                style: new TextStyle(color: Colors.white, fontSize: 19.0)),
            SizedBox(
              width: 10.0,
            ),
            Text(name,
                style: new TextStyle(color: Colors.white, fontSize: 19.0)),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(origin, style: new TextStyle(color: Colors.white, fontSize: 19.0)),
        SizedBox(
          height: 15.0,
        ),
        Text(destination,
            style: new TextStyle(color: Colors.white, fontSize: 19.0)),
        SizedBox(
          height: 15.0,
        ),
        Text("Tiempo de llegada: " + time,
            style: new TextStyle(color: Colors.white, fontSize: 19.0)),
      ],
    ),
  );
}
