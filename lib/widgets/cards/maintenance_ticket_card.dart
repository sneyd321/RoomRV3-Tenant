import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/widgets/Navigation/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../buttons/IconTextColumn.dart';

class MaintenanceTicketNotificationCard extends StatefulWidget {
  final Tenant tenant;
  final QueryDocumentSnapshot document;

  const MaintenanceTicketNotificationCard({
    Key? key,
    required this.document, required this.tenant,
  }) : super(key: key);

  @override
  State<MaintenanceTicketNotificationCard> createState() =>
      _MaintenanceTicketNotificationCardState();
}

class _MaintenanceTicketNotificationCardState
    extends State<MaintenanceTicketNotificationCard> {
  String parseTimestamp(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }

  void showMaintenanceTicketDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Maintenance Ticket #12",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text("Date Issued: 12/12/12",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Text("Urgency: ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.network(
                          "https://storage.googleapis.com/roomr-222721.appspot.com/MaintenanceTicket/MaintenanceTicket_4.jpg",
                        ).image,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("This is a description")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconTextColumn(
                  profileColor: Colors.blueGrey,
                  iconColor: Colors.white,
                  textColor: Colors.black,
                  icon: Icons.comment,
                  text: "Comment",
                  onClick: () {
                    Navigation().navigateToCommentsPage(context, widget.tenant, "UEWUV6", 1);
                  }),
              IconTextColumn(
                  profileColor: Colors.blueGrey,
                  iconColor: Colors.white,
                  textColor: Colors.black,
                  icon: Icons.date_range,
                  text: "Schedule",
                  onClick: () {
                    const snackBar = SnackBar(
                      content: Text('Feature Coming Soon'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }),
              IconTextColumn(
                  profileColor: Colors.blueGrey,
                  iconColor: Colors.white,
                  textColor: Colors.black,
                  icon: Icons.call,
                  text: "Call Landlord",
                  onClick: () {}),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMaintenanceTicketDialog();
      },
      child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: ListTile(
              visualDensity: const VisualDensity(vertical: 0.5),
              leading: const CircleAvatar(
                  child: Icon(
                    Icons.build,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red),
              title: const Text("Maintenance Ticket Reported"),
              subtitle: Text(
                  "Reported on ${parseTimestamp(widget.document["dateCreated"])}"),
              trailing: IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: (() {}),
              ))),
    );
  }
}
