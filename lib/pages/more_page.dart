import 'dart:convert';

import 'package:camera_example/services/_network.dart';
import 'package:camera_example/services/web_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:signature/signature.dart';

import '../business_logic/house.dart';
import '../business_logic/tenant.dart';
import '../graphql/graphql_client.dart';
import '../graphql/mutation_helper.dart';
import '../widgets/Navigation/navigation.dart';
import '../widgets/buttons/CallToActionButton.dart';

class MorePage extends StatefulWidget {
  final House house;
  final Tenant tenant;
  const MorePage({Key? key, required this.house, required this.tenant}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final SignatureController controller =
      SignatureController(exportBackgroundColor: Colors.white);
  String signitureError = "";
  String errorText = "";

  void copy(House house) async {
    String addressToCopy =
        "${house.lease.rentalAddress.getPrimaryAddress()} ${house.lease.rentalAddress.getSecondaryAddress()}";
    await Clipboard.setData(ClipboardData(text: addressToCopy));
    const snackBar = SnackBar(
      content: Text('Address Copied'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  
  void onDownloadLease(House house) async {
    if (widget.house.lease.documentURL == "") {
      setState(() {
        errorText =
            "Download link is missing. Please tell landlord to re generate lease and invite again.";
      });
    }
    if (kIsWeb) {
      WebNetwork webNetwork = WebNetwork();
      String filePath = webNetwork.downloadFromURL(house.lease.documentURL);
      webNetwork.openFile(filePath);
    } else {
      Network network = Network();
      String filePath = await network.downloadFromURL(
          widget.house.lease.documentURL, "Standard_Lease_Agreement.pdf");
      network.openFile(filePath);
    }
  }

  void showNotificationDialog(House house) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return GraphQLProvider(
            client: GQLClient().getClient(),
            child: MutationHelper(
              builder: ((runMutation) {
                return AlertDialog(
                    actions: [
                      TextButton(
                        child: const Text('Clear'),
                        onPressed: () {
                          controller.clear();
                        },
                      ),
                      TextButton(
                        child: const Text('Sign'),
                        onPressed: () async {
                          if (controller.isEmpty) {
                            setState(() {
                              signitureError = "Please enter a signature";
                            });
                          }
                          String base64EncodedSigniture =
                              base64Encode(await controller.toPngBytes() ?? []);
                          runMutation({
                            "tenant": widget.tenant.toJson(),
                            "signature": base64EncodedSigniture,
                            "houseKey": house.houseKey,
                            "documentURL": house.lease.documentURL
                          });
                        },
                      )
                    ],
                    content: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Standard_Lease_Agreement.pdf",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 16, bottom: 16, right: 8),
                                    child: CallToActionButton(
                                      text: "Download",
                                      onClick: () {
                                        onDownloadLease(house);
                                      },
                                    )),
                                Text(
                                  errorText,
                                  style: const TextStyle(color: Colors.red),
                                )
                              ],
                            ),
                          ),
                          ClipRRect(
                            child: SizedBox(
                              height: 125,
                              child: Signature(
                                controller: controller,
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(signitureError,
                                  style: const TextStyle(color: Colors.red))),
                        ],
                      ),
                    ));
              }),
              mutationName: 'signLease',
              onComplete: (json) {
                Navigator.pop(context);
                const snackBar = SnackBar(
                  content: Text(
                      'Sign sent, you will recieve a notification when signture completes'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: ListView(
            shrinkWrap: true,
            children: [
              GestureDetector(
                onTap: () {
                  copy(widget.house);
                },
                child: const ListTile(
                  leading: Icon(Icons.copy),
                  title: Text("Copy Address"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  showNotificationDialog(widget.house);
                },
                child: const ListTile(
                  leading: Icon(Icons.draw),
                  title: Text("Sign Lease"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigation().navigateToPaymentsPage(context, widget.house);
                },
                child: const ListTile(
                  leading: Icon(Icons.payment),
                  title: Text("View Payments"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigation().navigateToEditProfilePage(context, widget.tenant);
                },
                child: const ListTile(
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text("Edit Profile"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
