
import 'package:camera_example/business_logic/fields/field.dart';
import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/pages/login_page.dart';
import 'package:camera_example/services/graphql_client.dart';
import 'package:camera_example/widgets/Buttons/PrimaryButton.dart';
import 'package:camera_example/widgets/cards/download_lease_notification.dart';
import 'package:camera_example/widgets/form_fields/SimpleFormField.dart';
import 'package:camera_example/widgets/form_fields/TwoColumnRow.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:signature/signature.dart';
import '../graphql/mutation_helper.dart';

class SignUpPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String houseKey;
  final String documentURL;
  const SignUpPage(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.houseKey,
      required this.documentURL})
      : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignatureController controller =
      SignatureController(exportBackgroundColor: Colors.white);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reTypePasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Tenant tenant = Tenant();
  String password = "";
  String signitureError = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      firstNameController.text = widget.firstName;
      lastNameController.text = widget.lastName;
      tenant.setEmail(widget.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GQLClient().getClient(),
        child: MutationHelper(
            mutationName: "createTenant",
            onComplete: ((json) {
              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage(email: widget.email, password: password, houseKey: widget.houseKey)),
  );
            }),
            builder: ((runMutation) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Sign Up"),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TwoColumnRow(
                                      left: SimpleFormField(
                                        icon: Icons.account_circle,
                                        label: "First Name",
                                        textEditingController: firstNameController,
                                        onSaved: (value) {
                                          tenant.setFirstName(value!);
                                        },
                                        onValidate: ((value) {
                                          return FirstName(value!).validate();
                                        }),
                                      ),
                                      right: SimpleFormField(
                                        icon: Icons.account_circle,
                                        label: "Last Name",
                                        textEditingController: lastNameController,
                                        onSaved: (value) {
                                          tenant.setLastName(value!);
                                        },
                                        onValidate: ((value) {
                                          return LastName(value!).validate();
                                        }),
                                      )),
                                  SimpleFormField(
                                      icon: Icons.lock,
                                      label: "Password",
                                      textEditingController: passwordController,
                                      onSaved: (value) {},
                                      onValidate: ((value) {
                                        password = value!;
                                        return Password(value).validate();
                                      })),
                                  SimpleFormField(
                                      icon: Icons.lock,
                                      label: "Re-Type Password",
                                      textEditingController: reTypePasswordController,
                                      onSaved: (value) {
                                        tenant.setPassword(value!);
                                      },
                                      onValidate: ((value) {
                                        return ReTypePassword(value!)
                                            .validatePassword(password);
                                      })),
                                  Container(
                                    margin: const EdgeInsets.only(left: 4, right: 4),
                                    child: DownloadLeaseNotificationCard(
                                      tenant: Tenant(),
                                      houseKey: widget.houseKey,
                                      shouldSign: false,
                                        documentURL: widget.documentURL),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    PrimaryButton(Icons.account_box, "Create Account", (context)  async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        runMutation({
                          "houseKey": widget.houseKey,
                          "tenant": tenant.toJson()
                        });
                      }
                    })
                  ],
                ),
              );
            })));
  }
}
