import 'package:camera_example/business_logic/fields/field.dart';
import 'package:camera_example/business_logic/house.dart';
import 'package:camera_example/business_logic/login_tenant.dart';
import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/main.dart';
import 'package:camera_example/graphql/graphql_client.dart';

import 'package:camera_example/widgets/form_fields/EmailFormField.dart';
import 'package:camera_example/widgets/form_fields/HouseKeyFormField.dart';
import 'package:camera_example/widgets/form_fields/PasswordFormField.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../graphql/mutation_helper.dart';
import '../services/FirebaseConfig.dart';
import '../widgets/Navigation/navigation.dart';
import '../widgets/buttons/CallToActionButton.dart';

class LoginPage extends StatefulWidget {
  final String email;
  final String password;
  final String houseKey;
  const LoginPage(
      {Key? key,
      required this.email,
      required this.password,
      required this.houseKey})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RouteAware {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController houseKeyTextEditingController =
      TextEditingController();

  final LoginTenant loginTenant = LoginTenant();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailTextEditingController.text = widget.email;
    passwordTextEditingController.text = widget.password;
    houseKeyTextEditingController.text = widget.houseKey;
    SharedPreferences.getInstance().then((value) {
      String? sharedPreferencesHouseKey = value.getString("houseKey");
      if (sharedPreferencesHouseKey != null) {
        houseKeyTextEditingController.text = sharedPreferencesHouseKey;
      }

      String? sharedPreferencesEmail = value.getString("email");
      if (sharedPreferencesEmail != null) {
        emailTextEditingController.text = sharedPreferencesEmail;
      }
    });

    FirebaseConfiguration()
        .getToken()
        .then((value) => loginTenant.deviceId = value ?? "");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: MutationHelper(
          mutationName: "loginTenant",
          onComplete: (json) {
            Tenant tenant = Tenant.fromJson(json);
            House house = House();
            house.houseKey = loginTenant.houseKey;
            Navigation().navigateToDashboardPage(context, tenant, house);
          },
          builder: (runMutation) {
            return SafeArea(
                child: Scaffold(
              body: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(
                          top: 64,
                        ),
                        child: Column(
                          children: const [
                            Text(
                              "Room Renting",
                              style: TextStyle(
                                  color: Color(primaryColour), fontSize: 36),
                            ),
                            Text(
                              "Tenant",
                              style: TextStyle(color: Colors.blue, fontSize: 28),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 200,
                    ),
                    SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            EmailFormField(
                              textEditingController: emailTextEditingController,
                              onSaved: ((email) {
                                loginTenant.setEmail(email.value);
                              }),
                            ),
                            PasswordFormField(
                                textEditingController:
                                    passwordTextEditingController,
                                onSaved: (value) {
                                  loginTenant.setPassword(value!.trim());
                                },
                                label: "Password",
                                icon: Icons.password,
                                onValidate: (value) {
                                  return Password(value!).validate();
                                }),
                            HouseKeyFormField(
                                textEditingController:
                                    houseKeyTextEditingController,
                                onSaved: (value) {
                                  loginTenant.setHouseKey(value!);
                                })
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      child: CallToActionButton(
                          text: "Login",
                          onClick: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString("houseKey", loginTenant.houseKey);
                              prefs.setString("email", loginTenant.email);
                              runMutation({"login": loginTenant.toJson()});
                            }
                          }),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
