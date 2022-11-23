import 'dart:convert';

import 'package:camera_example/services/_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:signature/signature.dart';
import 'package:universal_html/html.dart';

import '../../graphql/mutation_helper.dart';
import '../../services/graphql_client.dart';
import '../../services/notification/download_lease_notification.dart';
import '../../services/web_network.dart';
import '../Buttons/SecondaryButton.dart';

class DownloadLeaseNotificationCard extends StatefulWidget {
  final String documentURL;
  final bool shouldSign;

  const DownloadLeaseNotificationCard({
    Key? key,
    required this.documentURL,
    this.shouldSign = true,
  }) : super(key: key);

  @override
  State<DownloadLeaseNotificationCard> createState() =>
      _DownloadLeaseNotificationCardState();
}

class _DownloadLeaseNotificationCardState
    extends State<DownloadLeaseNotificationCard> {
  final SignatureController controller =
      SignatureController(exportBackgroundColor: Colors.white);
  String signitureError = "";

  String errorText = "";

  void onDownloadLease() async {
    if (widget.documentURL == "") {
      setState(() {
        errorText =
            "Download link is missing. Please tell landlord to create new lease revision.";
      });
      return;
    }
    if (kIsWeb) {
      WebNetwork webNetwork = WebNetwork();
      String filePath = webNetwork.downloadFromURL(widget.documentURL);
      webNetwork.openFile(filePath);
    } else {
      Network network = Network();
      String filePath = await network.downloadFromURL(
          widget.documentURL, "StandardLeaseAgreement.pdf");
      network.openFile(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 75,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Standard_Lease_Agreement.pdf",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 16, right: 8),
                child: ElevatedButton(
                    onPressed: onDownloadLease, child: const Text("Download")),
              ),
              
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Text(
                  errorText,
                  style: const TextStyle(color: Colors.red),
                ),
        ),
        Visibility(
          visible: widget.shouldSign,
          child: SecondaryButton(Icons.pin_end, "Sign Lease", (context) {
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
                                String base64EncodedSigniture = base64Encode(
                                    await controller.toPngBytes() ?? []);
                                runMutation({
                                  "signature": base64EncodedSigniture,
                                });
                                Navigator.pop(context);
                              },
                            )
                          ],
                          content: Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: ClipRRect(
                                    child: SizedBox(
                                      height: 125,
                                      child: Signature(
                                        controller: controller,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(signitureError,
                                          style: const TextStyle(
                                              color: Colors.red))),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      mutationName: '',
                      onComplete: (json) {},
                    ),
                  );
                });
          }),
        ),
      ],
    );
  }
}
