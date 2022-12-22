import 'package:camera_example/business_logic/fields/field.dart';
import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/pages/login_page.dart';
import 'package:camera_example/graphql/graphql_client.dart';
import 'package:camera_example/services/_network.dart';
import 'package:camera_example/services/web_network.dart';
import 'package:camera_example/widgets/form_fields/PasswordFormField.dart';
import 'package:camera_example/widgets/form_fields/PhoneNumberFormField.dart';
import 'package:camera_example/widgets/form_fields/SimpleFormField.dart';
import 'package:camera_example/widgets/form_fields/TwoColumnRow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:signature/signature.dart';
import 'package:universal_html/html.dart';
import '../graphql/mutation_helper.dart';
import '../widgets/buttons/CallToActionButton.dart';
import '../widgets/cards/download_lease_notification.dart';

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
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reTypePasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Tenant tenant = Tenant();
  String password = "";
  String errorText = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      firstNameController.text = widget.firstName;
      lastNameController.text = widget.lastName;
      tenant.setEmail(widget.email);
    });
  }

  void onDownloadLease() async {
    if (widget.documentURL == "") {
      setState(() {
        errorText =
            "Download link is missing. Please tell landlord to re generate lease and invite again.";
      });
    }
    if (kIsWeb) {
      WebNetwork webNetwork = WebNetwork();
      String filePath = webNetwork.downloadFromURL(widget.documentURL);
      webNetwork.openFile(filePath);
    } else {
      Network network = Network();
      String filePath = await network.downloadFromURL(
          widget.documentURL, "Standard_Lease_Agreement.pdf");
      network.openFile(filePath);
    }
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
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                        email: widget.email,
                        password: password,
                        houseKey: widget.houseKey)),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: SimpleFormField(
                                          icon: Icons.account_circle,
                                          label: "First Name",
                                          textEditingController:
                                              firstNameController,
                                          onSaved: (value) {
                                            tenant.setFirstName(value!);
                                          },
                                          onValidate: ((value) {
                                            return FirstName(value!).validate();
                                          }),
                                        ),
                                  ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: MediaQuery.of(context).size.width / 2,
                                        child: SimpleFormField(
                                          icon: Icons.account_circle,
                                          label: "Last Name",
                                          textEditingController:
                                              lastNameController,
                                          onSaved: (value) {
                                            tenant.setLastName(value!);
                                          },
                                          onValidate: ((value) {
                                            return LastName(value!).validate();
                                          }),
                                        ),
                                      ),
                                  PhoneNumberFormField(
                                    textEditingController:
                                        phoneNumberController,
                                    onSaved: (value) {
                                      tenant.setPhoneNumber(value!);
                                    },
                                  ),
                                  PasswordFormField(
                                      icon: Icons.lock,
                                      label: "Password",
                                      textEditingController: passwordController,
                                      onSaved: (value) {},
                                      onValidate: ((value) {
                                        password = value!;
                                        return Password(value).validate();
                                      })),
                                  PasswordFormField(
                                      icon: Icons.lock,
                                      label: "Re-Type Password",
                                      textEditingController:
                                          reTypePasswordController,
                                      onSaved: (value) {
                                        tenant.setPassword(value!);
                                      },
                                      onValidate: ((value) {
                                        return ReTypePassword(value!)
                                            .validatePassword(password);
                                      })),
                                  Container(
                                    height: 100,
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Flexible(
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                "Standard_Lease_Agreement.pdf",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              )),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 16, bottom: 16, right: 8),
                                            child: CallToActionButton(
                                              text: "Download",
                                              onClick: () {
                                                onDownloadLease();
                                              },
                                            )),
                                        Text(
                                          errorText,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      child: CallToActionButton(
                          text: "Create Account",
                          onClick: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              runMutation({
                                "houseKey": widget.houseKey,
                                "tenant": tenant.toUpdateStateJson()
                              });
                            }
                          }),
                    )
                  ],
                ),
              );
            })));
  }
}
