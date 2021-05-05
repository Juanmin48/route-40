import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:route_40/model/data_model.dart';
import 'package:route_40/screens/main_page.dart';

Future<Widget> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  return Provider<DataModel>(
    create: (_) => DataModel(),
    child: Homepage(),
  );
  // return ChangeNotifierProvider<DataModel>(
  //     create: (context) => DataModel(),
  //     child: Consumer<DataModel>(builder: (context, model, child) {
  //       return MaterialApp(
  //         home: Scaffold(
  //           body: Center(
  //             child: Homepage(),
  //           ),
  //         ),
  //       );
  //     }));
}

void main() {
  group('Integration test', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    testWidgets('add user to database', (WidgetTester tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithText(MaterialButton, "Ingresar"));
      await tester.pumpAndSettle(Duration(seconds: 5));
    });
  });
}
