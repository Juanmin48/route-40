import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:route_40/model/data_controller.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataController dc = Get.find();
    bool user = dc.user != null;
    return new Drawer(
      child: Container(
        color: Color.fromRGBO(255, 154, 81, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.only(top: 25, right: 15),
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )),
            Expanded(
                flex: 0,
                child: Center(
                    child: Text("Menú",
                        style: TextStyle(
                          fontSize: 30,
                        )))),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(40),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('images/Route.png'),
                    fit: BoxFit.contain,
                  )),
                ),
              ),
            ),
            ListView(shrinkWrap: true, children: [
              Container(
                color: Color.fromRGBO(255, 174, 116, 1),
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Buscar',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false),
                ),
              ),
              Divider(
                color: Colors.black,
                height: 0,
                thickness: 1,
              ),
              Container(
                color: Color.fromRGBO(255, 174, 116, 1),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Usuario',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  onTap: () {
                    if (user) {
                      // print(dc.resultquery);
                      Get.toNamed('/userprofile');
                    } else {
                      Get.toNamed('/login');
                    }
                  },
                ),
              ),
              Divider(
                color: Colors.black,
                height: 0,
                thickness: 1,
              ),
              Container(
                color: Color.fromRGBO(255, 174, 116, 1),
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Historial',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  onTap: () {},
                ),
              ),
              Divider(
                color: Colors.black,
                height: 0,
                thickness: 1,
              ),
            ]),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            user
                ? Expanded(
                    flex: 1,
                    child: TextButton(
                      child: Text(
                        "Cerrar sesión",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  )
                : Expanded(
                    flex: 1,
                    child: TextButton(
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () => Get.toNamed('/login'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
