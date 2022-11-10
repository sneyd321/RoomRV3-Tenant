import 'package:camera_example/business_logic/fields/field.dart';
import 'package:camera_example/business_logic/login_tenant.dart';
import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/pages/tenant_view_pager.dart';
import 'package:camera_example/services/graphql_client.dart';
import 'package:camera_example/widgets/Buttons/PrimaryButton.dart';
import 'package:camera_example/widgets/form_fields/EmailFormField.dart';
import 'package:camera_example/widgets/form_fields/PasswordFormField.dart';
import 'package:camera_example/widgets/form_fields/SimpleFormField.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/mutation_helper.dart';
import '../services/FirebaseConfig.dart';

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

class _LoginPageState extends State<LoginPage> {
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
    FirebaseConfiguration()
        .getToken()
        .then((value) => loginTenant.deviceId = value ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: MutationHelper(
          mutationName: "loginTenant",
          onComplete: (json) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TenantViewPager(
                        tenant: Tenant.fromJson(json),
                        houseKey: loginTenant.houseKey,
                      )),
            );
          },
          builder: (runMutation) {
            return SafeArea(
                child: Scaffold(
              body: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                              top: 16,
                            ),
                            child: const Center(
                                child: Text(
                              "RoomR",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 36),
                            ))),
                        const SizedBox(
                          height: 200,
                        ),
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
                              loginTenant.setPassword(value!);
                            },
                            label: "Password",
                            icon: Icons.password,
                            onValidate: (value) {
                              return Password(value!).validate();
                            }),
                        SimpleFormField(
                          icon: Icons.key,
                          label: "House Key",
                          textEditingController: houseKeyTextEditingController,
                          onSaved: ((value) {
                            loginTenant.setHouseKey(value!);
                          }),
                          onValidate: ((value) {
                            return Password(value!).validate();
                          }),
                        ),
                        PrimaryButton(Icons.login, "Login", (context) async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            String? token =
                                await FirebaseConfiguration().getToken();
                                print(token);
                            if (token != null) {
                              loginTenant.setDeviceId(token);
                            }
                            runMutation({"login": loginTenant.toJson()});
                          }
                        })
                      ],
                    )),
              ),
            ));
          }),
    );
  }
}
