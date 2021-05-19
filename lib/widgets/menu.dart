import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:route_40/model/data_controller.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  DataController dc = Get.find();
  bool _user = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _user = dc.user != null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {
                    if (Get.currentRoute == "/") {
                      Navigator.of(context).pop();
                    } else {
                      dc.goback = false;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
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
                  leading: Icon(Icons.person),
                  title: Text('Usuario',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  onTap: () {
                    if (Get.currentRoute == "/userprofile") {
                      Navigator.of(context).pop();
                    } else {
                      if (_user) {
                        // print(dc.resultquery);
                        Get.toNamed('/userprofile');
                      } else {
                        Get.toNamed('/login');
                      }
                    }
                  },
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
            _user
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
                      onPressed: () async {
                        await dc.signOut();
                        setState(() {
                          _user = false;
                        });
                        if ((Get.currentRoute == "/rdetails") ||
                            (Get.currentRoute == "/froutes")) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false);
                        }
                      },
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
