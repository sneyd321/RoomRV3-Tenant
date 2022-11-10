import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/firebase_options.dart';
import 'package:camera_example/pages/login_page.dart';
import 'package:camera_example/pages/sign_up_page.dart';
import 'package:camera_example/pages/tenant_view_pager.dart';
import 'package:camera_example/services/FirebaseConfig.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'pages/maintenance_ticket_camera_page.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const SignUpPage(firstName: "Ryan", lastName: "Sneyd", email: "ryan.sneyd@hotmail.com", houseKey: "8T5ST7", documentURL: "https://storage.googleapis.com/roomr-222721.appspot.com/OntarioLease/Lease_123.pdf"),//TenantViewPager(houseKey: "Z14M4C", tenant: Tenant(),), //const LoginPage(email: "", password: "", houseKey: "",),LoginPage(email: "", password: "", houseKey: "",),
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
              pageView = SignUpPage(firstName: firstName, lastName: lastName, email: email, houseKey: houseKey, documentURL: documentURL);
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
