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
      await tester.pumpAndSettle(Duration(seconds: 5));

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

    testWidgets('Try to draw in the map the selected route',
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

    testWidgets('Try to log in with correct credentials',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/login', Get.currentRoute);

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);

      final email = find.byKey(Key('emailL'));
      final password = find.byKey(Key('passwordL'));

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'gus@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');

      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(find.byKey(Key('loginG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/', Get.currentRoute);
      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Cerrar sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Cerrar sesión"));
      await tester.pumpAndSettle(Duration(seconds: 5));
    });

    testWidgets('Try to log in but the fields are empty',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/login', Get.currentRoute);

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);

      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/login', Get.currentRoute);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Try to log in with incorrect credentials',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final email = find.byKey(Key('emailL'));
      final password = find.byKey(Key('passwordL'));
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/login', Get.currentRoute);

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'gus@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '12345');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('loginG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/login', Get.currentRoute);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Try to register with correct credentials',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/login', Get.currentRoute);

      expect(find.widgetWithText(TextButton, "¿No tienes cuenta? Registrate"),
          findsOneWidget);
      await tester.tap(
          find.widgetWithText(TextButton, "¿No tienes cuenta? Registrate"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/register', Get.currentRoute);

      final email = find.byKey(Key('emailR'));
      final password = find.byKey(Key('passwordR'));
      final conpassword = find.byKey(Key('confirmationPass'));
      final name = find.byKey(Key('nameR'));

      await tester.tap(name);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(name, 'Jonathan');
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'jon11@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(find.byKey(Key('registerG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(conpassword);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(conpassword, '123456');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('registerG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(find.widgetWithText(MaterialButton, "Registrar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/', Get.currentRoute);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Cerrar sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Cerrar sesión"));
      await tester.pumpAndSettle(Duration(seconds: 5));
    });

    testWidgets('Try to register but the fields are empty',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/login', Get.currentRoute);

      expect(find.widgetWithText(TextButton, "¿No tienes cuenta? Registrate"),
          findsOneWidget);
      await tester.tap(
          find.widgetWithText(TextButton, "¿No tienes cuenta? Registrate"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/register', Get.currentRoute);

      await tester.tap(find.widgetWithText(MaterialButton, "Registrar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/register', Get.currentRoute);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets(
        'Try to register but the password and confirmation password do no match',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/login', Get.currentRoute);

      expect(find.widgetWithText(TextButton, "¿No tienes cuenta? Registrate"),
          findsOneWidget);
      await tester.tap(
          find.widgetWithText(TextButton, "¿No tienes cuenta? Registrate"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/register', Get.currentRoute);

      final email = find.byKey(Key('emailR'));
      final password = find.byKey(Key('passwordR'));
      final conpassword = find.byKey(Key('confirmationPass'));
      final name = find.byKey(Key('nameR'));

      await tester.tap(name);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(name, 'Jonathan');
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'jon2@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(find.byKey(Key('registerG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(conpassword);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(conpassword, '12345');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('registerG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(find.widgetWithText(MaterialButton, "Registrar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/register', Get.currentRoute);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Try to register but the email is already in use',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/login', Get.currentRoute);

      expect(find.widgetWithText(TextButton, "¿No tienes cuenta? Registrate"),
          findsOneWidget);
      await tester.tap(
          find.widgetWithText(TextButton, "¿No tienes cuenta? Registrate"));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect('/register', Get.currentRoute);

      final email = find.byKey(Key('emailR'));
      final password = find.byKey(Key('passwordR'));
      final conpassword = find.byKey(Key('confirmationPass'));
      final name = find.byKey(Key('nameR'));

      await tester.tap(name);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(name, 'Gustavo');
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'gus@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(find.byKey(Key('registerG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(conpassword);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(conpassword, '123456');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('registerG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(find.widgetWithText(MaterialButton, "Registrar"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('/register', Get.currentRoute);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Try to get the user info', (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final email = find.byKey(Key('emailL'));
      final password = find.byKey(Key('passwordL'));
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/login', Get.currentRoute);

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'gus@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('loginG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/', Get.currentRoute);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(ListTile, "Usuario"), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, "Usuario"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/userprofile', Get.currentRoute);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Cerrar sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Cerrar sesión"));
      await tester.pumpAndSettle(Duration(seconds: 5));
    });

    testWidgets(
        'Try to get the user´s favorite routes and there is at least one favorite route',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final email = find.byKey(Key('emailL'));
      final password = find.byKey(Key('passwordL'));
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/login', Get.currentRoute);

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'gus@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('loginG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/', Get.currentRoute);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(ListTile, "Usuario"), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, "Usuario"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/userprofile', Get.currentRoute);

      expect(find.widgetWithText(MaterialButton, "Rutas favoritas"),
          findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Rutas favoritas"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/froutes', Get.currentRoute);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.widgetWithText(MaterialButton, "Ruta N°1"), findsOneWidget);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, "Cerrar sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Cerrar sesión"));
      await tester.pumpAndSettle(Duration(seconds: 5));
    });

    testWidgets(
        'Try to get the user´s favorite routes and there are no favorite routes',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final email = find.byKey(Key('emailL'));
      final password = find.byKey(Key('passwordL'));
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/login', Get.currentRoute);

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'jon@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('loginG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/', Get.currentRoute);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(ListTile, "Usuario"), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, "Usuario"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/userprofile', Get.currentRoute);

      expect(find.widgetWithText(MaterialButton, "Rutas favoritas"),
          findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Rutas favoritas"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/userprofile', Get.currentRoute);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Try to get the details of a favorite route',
        (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final email = find.byKey(Key('emailL'));
      final password = find.byKey(Key('passwordL'));
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/login', Get.currentRoute);

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'gus@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('loginG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/', Get.currentRoute);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(ListTile, "Usuario"), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, "Usuario"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/userprofile', Get.currentRoute);

      expect(find.widgetWithText(MaterialButton, "Rutas favoritas"),
          findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Rutas favoritas"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/froutes', Get.currentRoute);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.widgetWithText(MaterialButton, "Ruta N°1"), findsOneWidget);

      await tester.tap(find.widgetWithText(MaterialButton, "Ruta N°1"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/() => RDetails', Get.currentRoute);
    });

    testWidgets('Try to add a favorite route', (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final email = find.byKey(Key('emailL'));
      final password = find.byKey(Key('passwordL'));
      final origin = find.byKey(Key('origin'));
      final destination = find.byKey(Key('destination'));
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/login', Get.currentRoute);

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'gus@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('loginG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/', Get.currentRoute);

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

      expect(
          find.widgetWithIcon(IconButton, Icons.star_border), findsOneWidget);
      await tester.tap(find.widgetWithIcon(IconButton, Icons.star_border));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.widgetWithIcon(IconButton, Icons.star), findsOneWidget);
    });

    testWidgets('Try to delete a favorite route', (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      final email = find.byKey(Key('emailL'));
      final password = find.byKey(Key('passwordL'));
      final origin = find.byKey(Key('origin'));
      final destination = find.byKey(Key('destination'));
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithIcon(MaterialButton, Icons.menu));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(TextButton, "Iniciar Sesión"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Iniciar Sesión"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/login', Get.currentRoute);

      await tester.tap(email);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(email, 'gus@gmail.com');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(password);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.enterText(password, '123456');
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byKey(Key('loginG')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.widgetWithText(MaterialButton, "Ingresar"), findsOneWidget);
      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect('/', Get.currentRoute);

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

      expect(find.widgetWithIcon(IconButton, Icons.star), findsOneWidget);
      await tester.tap(find.widgetWithIcon(IconButton, Icons.star));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(
          find.widgetWithIcon(IconButton, Icons.star_border), findsOneWidget);
    });
  });
}
