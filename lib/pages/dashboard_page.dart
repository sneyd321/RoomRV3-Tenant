import 'dart:convert';

import 'package:camera_example/main.dart';
import 'package:camera_example/services/_network.dart';
import 'package:camera_example/services/graphql_client.dart';
import 'package:camera_example/services/web_network.dart';
import 'package:camera_example/widgets/Navigation/bottom_nav_bar.dart';
import 'package:camera_example/widgets/Navigation/navigation.dart';
import 'package:camera_example/widgets/builders/notifications_limit.dart';
import 'package:camera_example/widgets/cards/HouseMenuCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../Helper/BottomSheetHelper.dart';
import '../business_logic/house.dart';
import '../business_logic/tenant.dart';
import '../graphql/mutation_helper.dart';
import '../graphql/query_helper.dart';
import '../widgets/buttons/CallToActionButton.dart';
import 'create_maintenance_ticket_page.dart';

class DashboardPage extends StatefulWidget {
  final Tenant tenant;
  final House house;

  const DashboardPage({Key? key, required this.tenant, required this.house})
      : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SignatureController controller =
      SignatureController(exportBackgroundColor: Colors.white);

  String signitureError = "";

  String errorText = "";

  ImagePicker picker = ImagePicker();
  XFile? image;

  Widget leftPanel(House house) {
    return Column(
      children: [
        Expanded(child: NotificationLimit(house: house, tenant: widget.tenant)),
        Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.topRight,
            child: FloatingActionButton.extended(
              onPressed: () async {
                image = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                  imageQuality: 100,
                );

                if (image != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateMaintenanceTicketPage(
                              file: image!,
                              houseKey: widget.house.houseKey,
                              tenant: widget.tenant)));
                }
              },
              label: const Text("Report Maintenance Ticket"),
              icon: const Icon(Icons.add),
            ))
      ],
    );
  }

  Widget rightPanel(House house) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ListView(
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              copy();
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
              showNotificationDialog(house);
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
              Navigation().navigateToPaymentsPage(context, house);
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
    );
  }

  void copy() async {
    String addressToCopy =
        "${widget.house.lease.rentalAddress.getPrimaryAddress()} ${widget.house.lease.rentalAddress.getSecondaryAddress()}";
    await Clipboard.setData(ClipboardData(text: addressToCopy));
    const snackBar = SnackBar(
      content: Text('Address Copied'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                  content: Text('Sign sent, you will recieve a notification when signture completes'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: SafeArea(
          child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(),
          body: QueryHelper(
            isList: false,
            onComplete: (json) {
              if (json == null) return const CircularProgressIndicator();
              House house = House.fromJson(json);

              return Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        leftPanel(house),
                        rightPanel(
                          house,
                        )
                      ],
                    ),
                  ),
                  const ColoredBox(
                    color: Color(primaryColour),
                    child: TabBar(
                      tabs: [
                        Tab(
                          icon: Icon(Icons.notifications),
                          text: "Notifications",
                        ),
                        Tab(
                          icon: Icon(Icons.list),
                          text: "More",
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            queryName: 'getHouse',
            variables: {"houseKey": widget.house.houseKey},
          ),
        ),
      )),
    );
  }
}
