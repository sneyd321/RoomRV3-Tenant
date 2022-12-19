import 'dart:convert';

import 'package:camera_example/business_logic/fields/field.dart';
import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../graphql/mutation_helper.dart';
import '../services/graphql_client.dart';
import '../widgets/Buttons/CallToActionButton.dart';
import '../widgets/Buttons/MemoryPhoto.dart';
import '../widgets/Buttons/ProfilePicture.dart';
import '../widgets/form_fields/SimpleFormField.dart';
import '../widgets/form_fields/TwoColumnRow.dart';

class EditProfilePage extends StatefulWidget {
  final Tenant tenant;
  const EditProfilePage({Key? key, required this.tenant}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Tenant tenant = Tenant();
  ImagePicker picker = ImagePicker();
  XFile? image;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameTextEditingController =
      TextEditingController();
  final TextEditingController lastNameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneNumberTextEditingController =
      TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    tenant = widget.tenant;
    firstNameTextEditingController.text = tenant.firstName;
    lastNameTextEditingController.text = tenant.lastName;
    emailTextEditingController.text = tenant.email;
    
    phoneNumberTextEditingController.text = tenant.phoneNumber;
  }

  @override
  void dispose() {
    super.dispose();
    firstNameTextEditingController.dispose();
    lastNameTextEditingController.dispose();
    emailTextEditingController.dispose();
    phoneNumberTextEditingController.dispose();
  }

  Future<void> openGallery(
      MultiSourceResult<Object?> Function(Map<String, dynamic>,
              {Object? optimisticResult})
          runMutation) async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      runMutation({
        "houseKey": "",
        "tenantProfile": {
          "firstName": tenant.firstName,
          "lastName": tenant.lastName,
          "firebaseId": "",
          "imageURL": tenant.profileURL
        },
        "image": base64Encode(await image!.readAsBytes())
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: SafeArea(
          child: MutationHelper(
        builder: (runMutation) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Update Profile"),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    MutationHelper(
                        onComplete: (json) {
                        },
                        mutationName: "scheduleTenantProfile",
                        builder: (runMutation) {
                          return Center(
                            child: Visibility(
                              visible: image == null,
                              replacement: MemoryPhoto(
                                bytes: image?.readAsBytes(),
                                text: widget.tenant.getFullName(),
                                profileColor: Colors.blueGrey,
                                profileSize: 60,
                                iconSize: 80,
                                textSize: 18,
                                textColor: Color(primaryColour),
                                onClick: () async {
                                  await openGallery(runMutation);
                                },
                              ),
                              child: ProfilePicture(
                                  profileColor: Colors.blueGrey,
                                  profileSize: 60,
                                 
                                  textSize: 18,
                                  profileURL: tenant.profileURL,
                                  textColor: Color(primaryColour),
                                  text: widget.tenant.getFullName(),
                                  onClick: () async {
                                    await openGallery(runMutation);
                                  }),
                            ),
                          );
                        }),
                    TwoColumnRow(
                        left: SimpleFormField(
                          label: "First Name",
                          icon: Icons.account_circle,
                          textEditingController: firstNameTextEditingController,
                          onSaved: (value) {
                            tenant.setFirstName(value!.trim());
                          },
                          onValidate: (String? value) {
                            return Name(value!).validate();
                          },
                        ),
                        right: SimpleFormField(
                          label: "Last Name",
                          icon: Icons.account_circle,
                          textEditingController: lastNameTextEditingController,
                          onSaved: (value) {
                            tenant.setLastName(value!.trim());
                          },
                          onValidate: (String? value) {
                            return Name(value!).validate();
                          },
                        )),
                    SimpleFormField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      textEditingController: phoneNumberTextEditingController,
                      onSaved: (value) {
                        tenant.setPhoneNumber(value!.trim());
                      },
                      onValidate: (value) {
                        return PhoneNumber(value!).validate();
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(8),
                      child: CallToActionButton(
                          text: "Update",
                          onClick: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              runMutation({"tenant": tenant.toTenantInput()});
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        mutationName: 'updateTenant',
        onComplete: (json) {},
      )),
    );
  }
}
