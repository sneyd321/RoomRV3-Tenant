import 'dart:convert';

import 'package:camera_example/business_logic/tenant.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../business_logic/house.dart';
import '../graphql/mutation_helper.dart';
import '../graphql/graphql_client.dart';
import '../widgets/Navigation/navigation.dart';
import '../widgets/buttons/CallToActionButton.dart';
import '../widgets/buttons/ProfilePicture.dart';

class ProfilePage extends StatefulWidget {
  final Tenant tenant;
  final House house;

  const ProfilePage({Key? key, required this.tenant, required this.house}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<String> items = const ["Edit Profile", "Delete Profile"];
  Tenant tenant = Tenant();
  ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    tenant = widget.tenant;
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
                title: const Text("Profile"),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProfilePicture(
                      profileColor: Colors.blueGrey,
                      profileSize: 80,
                     
                      textSize: 18,
                      profileURL: tenant.profileURL,
                      textColor: Colors.black,
                      text: widget.tenant.getFullName(),
                      onClick: () {}),
                  Container(
                      margin: const EdgeInsets.all(16),
                      child: CallToActionButton(
                          text: "Change Picture",
                          onClick: () async {
                            image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              runMutation({
                                "houseKey": widget.house.houseKey,
                                "tenantProfile": {
                                  "firstName": tenant.firstName,
                                  "lastName": tenant.lastName,
                                  "firebaseId": widget.house.firebaseId,
                                  "imageURL": tenant.profileURL
                                },
                                "image": base64Encode(await image!.readAsBytes())
                              });
                            }
                          })),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          Color color = Colors.black;
                          if (items[index].contains("Delete")) {
                            color = Colors.red;
                          }
                          return GestureDetector(
                            onTap: () async {
                              switch (index) {
                                case 0:
                                  Tenant? updatedTenant = await Navigation()
                                      .navigateToEditProfilePage(
                                          context, widget.tenant);
                                  if (updatedTenant != null) {
                                    setState(() {
                                      tenant = updatedTenant;
                                    });
                                  }
    
                                  break;
                                case 1:
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return GraphQLProvider(
                                        client: GQLClient().getClient(),
                                        child: MutationHelper(
                                          builder: (runMutation) {
                                            return AlertDialog(
                                                actions: [
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                                content: Row(
                                                  children: const [
                                                    CircleAvatar(
                                                      backgroundColor: Colors.red,
                                                      child: Icon(
                                                        Icons.warning,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        "Are you sure you want to delete your account?",
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                          },
                                          mutationName: 'deleteTenant',
                                          onComplete: (json) {
                                            Navigator.popUntil(context,
                                                (route) => route.isFirst);
                                          },
                                        ),
                                      );
                                    },
                                  );
                              }
                            },
                            child: ListTile(
                              title: Text(
                                items[index],
                                style: TextStyle(color: color),
                              ),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: color,
                              ),
                            ),
                          );
                        }),
                        separatorBuilder: (context, index) {
                          Color color = Colors.black;
                          return Divider(
                            color: color,
                          );
                        },
                        itemCount: items.length),
                  )
                ],
              ),
            );
          }, 
          mutationName: 'scheduleTenantProfile', 
          onComplete: (json) { 
    
           },
        ),
      ),
    );
  }
}
