
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../business_logic/house.dart';
import '../../business_logic/maintenance_ticket_notification.dart';
import '../../business_logic/tenant.dart';
import '../cards/download_lease_notification.dart';
import '../cards/maintenance_ticket_card.dart';
import '../listviews/CardSliverListView.dart';


class NotificationStreamBuilder extends StatefulWidget {
  final House house;
  final Tenant tenant;
  const NotificationStreamBuilder({Key? key, required this.house, required this.tenant})
      : super(key: key);

  @override
  State<NotificationStreamBuilder> createState() =>
      _NotificationStreamBuilderState();
}

class _NotificationStreamBuilderState extends State<NotificationStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('House')
            .doc(widget.house.firebaseId)
            .collection("Tenant")
            .orderBy("dateCreated", descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Text("Loading");
          }
          print(widget.house.firebaseId);
          QuerySnapshot querySnapshot = snapshot.data!;
          print(querySnapshot.docs.map((e) => e.id));
          return CardSliverListView(
            items: querySnapshot.docs,
            builder: (context, index) {
              QueryDocumentSnapshot document = querySnapshot.docs[index];
            
              switch (document.get("Name")) {
                case "MaintenanceTicket":
                  return MaintenanceTicketNotificationCard(
                    tenant: widget.tenant,
                    maintenanceTicketNotification:
                        MaintenanceTicketNotification.fromJson(
                            document.data() as Map<String, dynamic>),
                  );
                case "DownloadLease":
                  return DownloadLeaseNotificationCard(
                      documentURL: document.get("data")["documentURL"]);
              }
            },
            controller: ScrollController(),
          );
        },
      ),
    );
  }
}
