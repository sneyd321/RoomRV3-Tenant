import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/firebase_options.dart';
import 'package:camera_example/pages/login_page.dart';
import 'package:camera_example/pages/sign_up_page.dart';
import 'package:camera_example/services/FirebaseConfig.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseConfiguration().initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initHiveForFlutter();
  runApp(MyApp());
}

const int primaryColour = 0xFF000000;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [ routeObserver ],
      theme: ThemeData(
          primarySwatch: const MaterialColor(
        primaryColour,
        <int, Color>{
          50: Color(0xFF000000),
          100: Color(0xFF000000),
          200: Color(0xFF000000),
          300: Color(0xFF000000),
          400: Color(0xFF000000),
          500: Color(primaryColour),
          600: Color(0xFF000000),
          700: Color(0xFF000000),
          800: Color(0xFF000000),
          900: Color(0xFF000000),
        },
      )),
      home: const LoginPage(email: "", password: "", houseKey: ""),
      onGenerateRoute: (settings) {
        Widget? pageView;
        if (settings.name != null) {
          Uri uriData = Uri.parse(settings.name!);

          switch (uriData.path) {
            case '/SignUp':
              String firstName = uriData.queryParameters["firstName"] ?? "";
              String lastName = uriData.queryParameters["lastName"] ?? "";
              String email = uriData.queryParameters["email"] ?? "";
              String houseKey = uriData.queryParameters["houseKey"] ?? "";
              String documentURL = uriData.queryParameters["documentURL"] ?? "";
              pageView = SignUpPage(
                  firstName: firstName,
                  lastName: lastName,
                  email: email,
                  houseKey: houseKey,
                  documentURL: documentURL);
              break;
          }
        }
        if (pageView != null) {
          return MaterialPageRoute(
              builder: (BuildContext context) => pageView!);
        }
      },
    );
  }
}
