import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:route_40/model/data_controller.dart';
import 'package:route_40/screens/main_page.dart';

Future<Widget> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(DataController());
  return MaterialApp(
    home: Scaffold(
        body: Center(
          child: Homepage(),
        ),
      ),
  );
}

void main() {
  group('Integration test', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    testWidgets('add user to database', (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.press(find.widgetWithText(MaterialButton, "Iniciar sesión"));
      await tester.pumpAndSettle(Duration(seconds: 5));
    });
  });
}
