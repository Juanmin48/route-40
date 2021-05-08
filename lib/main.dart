import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/screens/fav_routes.dart';
import 'package:route_40/screens/login.dart';
import 'package:route_40/screens/main_page.dart';
import 'package:route_40/screens/proutes.dart';
import 'package:route_40/screens/register.dart';
import 'package:route_40/screens/user_profile.dart';
import 'package:route_40/widgets/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(DataController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Route40',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        drawer: Menu(),
        body: Center(
          child: Homepage(),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => new Homepage(),
        '/login': (BuildContext context) => new Login(),
        '/register': (BuildContext context) => new Register(),
        '/proutes': (BuildContext context) => new PRoutes(),
        '/froutes': (BuildContext context) => new FRoutes(),
        '/userprofile': (BuildContext context) => new UserProfile(),
      },
    );
  }
}
