import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/screens/fav_routes.dart';
import 'package:route_40/screens/login.dart';
import 'package:route_40/screens/main_page.dart';
import 'package:route_40/screens/proutes.dart';
import 'package:route_40/screens/register.dart';
import 'package:route_40/screens/user_profile.dart';
import 'package:route_40/widgets/menu.dart';

Future<Widget> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(DataController());
  return GetMaterialApp(
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

void main() {
  group('Integration test', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    testWidgets('try get routes and there is at least one possible route',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final origin = find.byKey(Key('origin'));
      final destination = find.byKey(Key('destination'));
      await tester.pumpWidget(w);

      await tester.tap(origin);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(origin, '11.006058664612853,-74.82924466825544');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(destination);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(
          destination, '10.992846496729307,-74.81869306099304');

      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.widgetWithText(MaterialButton, "Buscar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/proutes', Get.currentRoute);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.widgetWithText(MaterialButton, "Ruta N°1"), findsOneWidget);
    });

    testWidgets('try get routes but there are not possible routes',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final origin = find.byKey(Key('origin'));
      final destination = find.byKey(Key('destination'));
      await tester.pumpWidget(w);

      await tester.tap(origin);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(origin, '10.99575811271032,-74.7947410740485');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(destination);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(
          destination, '10.991755078430286,-74.78927383901387');

      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.widgetWithText(MaterialButton, "Buscar"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/', Get.currentRoute);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('try get routes but the fields are empty',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithText(MaterialButton, "Buscar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/', Get.currentRoute);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Draw in the map the selected route',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final origin = find.byKey(Key('origin'));
      final destination = find.byKey(Key('destination'));
      await tester.pumpWidget(w);

      await tester.tap(origin);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(origin, '11.006058664612853,-74.82924466825544');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(destination);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(
          destination, '10.992846496729307,-74.81869306099304');

      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.widgetWithText(MaterialButton, "Buscar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/proutes', Get.currentRoute);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.widgetWithText(MaterialButton, "Ruta N°1"), findsOneWidget);

      await tester.tap(find.widgetWithText(MaterialButton, "Ruta N°1"));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect('/() => RDetails', Get.currentRoute);
    });

    testWidgets('Draw in the map the selected route',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 5));

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/login', Get.currentRoute);
    });
  });
}
