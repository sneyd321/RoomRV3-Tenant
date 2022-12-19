import 'dart:convert';

import 'package:camera_example/graphql/mutation_helper.dart';
import 'package:camera_example/services/_network.dart';
import 'package:camera_example/services/graphql_client.dart';
import 'package:camera_example/widgets/buttons/CallToActionButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';


import 'package:signature/signature.dart';

import '../../services/notification/download_lease_notification.dart';
import '../../services/web_network.dart';

class DownloadLeaseNotificationCard extends StatefulWidget {
  final QueryDocumentSnapshot document;

  const DownloadLeaseNotificationCard({Key? key, required this.document})
      : super(key: key);

  @override
  State<DownloadLeaseNotificationCard> createState() =>
      _DownloadLeaseNotificationCardState();
}

class _DownloadLeaseNotificationCardState
    extends State<DownloadLeaseNotificationCard> {
  DownloadLeaseNotification downloadLeaseNotification =
      DownloadLeaseNotification();
  final SignatureController controller =
      SignatureController(exportBackgroundColor: Colors.white);
  String signitureError = "";

  String errorText = "";

  late String documentURL;
  late String houseKey;
  late String documentName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    documentURL = widget.document.get("data")["documentURL"];
    houseKey = widget.document.get("houseKey");
    documentName = widget.document.get("data")["documentName"];
  }

  String parseTimestamp(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }

  void onDownloadLease() async {
    if (documentURL == "") {
      setState(() {
        errorText =
            "Download link is missing. Please tell landlord to re generate lease and invite again.";
      });
    }
    if (kIsWeb) {
      WebNetwork webNetwork = WebNetwork();
      String filePath = webNetwork.downloadFromURL(documentURL);
      await downloadLeaseNotification.localNotificationService.cancel(0);
      webNetwork.openFile(filePath);
    } else {
      Network network = Network();
      String filePath =
          await network.downloadFromURL(documentURL, documentName);
      await downloadLeaseNotification.localNotificationService.cancel(0);
      network.openFile(filePath);
    }
  }

  void showNotificationDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
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
                                onDownloadLease();
                              },
                            )),
                        Text(
                          errorText,
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                 
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(signitureError,
                          style: const TextStyle(color: Colors.red))),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: MutationHelper(
        builder: (runMutation) {
          return GestureDetector(
            onTap: () {
              showNotificationDialog();
            },
            child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: ListTile(
                    visualDensity: const VisualDensity(vertical: 0.5),
                    leading: const CircleAvatar(
                        child: Icon(
                          Icons.assignment,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.blue),
                    title: const Text("Lease Revised"),
                    subtitle: Text(
                        "Created on ${parseTimestamp(widget.document["dateCreated"])}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: (() {
                        showNotificationDialog();
                      }),
                    ))),
          );
        },
        mutationName: 'scheduleLease',
        onComplete: (json) {},
      ),
    );
  }
}
