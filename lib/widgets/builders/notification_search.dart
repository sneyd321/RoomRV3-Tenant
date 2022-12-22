import 'package:camera_example/business_logic/house.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../business_logic/tenant.dart';
import '../cards/ApproveTenantNotification.dart';
import '../cards/custom_notification_card.dart';
import '../cards/download_lease_notification.dart';
import '../cards/maintenance_ticket_card.dart';
import '../listviews/CardSliverListView.dart';

class NotificationSearch extends StatefulWidget {
  final Tenant tenant;
  final House house;
  final List<QueryDocumentSnapshot> documents;
  const NotificationSearch(
      {Key? key, required this.tenant, required this.documents, required this.house})
      : super(key: key);

  @override
  State<NotificationSearch> createState() => _NotificationSearchState();
}

class _NotificationSearchState extends State<NotificationSearch> {
  final TextEditingController searchTextEditingController =
      TextEditingController();
  List<QueryDocumentSnapshot> queryDocumentSnapshots = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryDocumentSnapshots = widget.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: searchTextEditingController,
            onChanged: (value) {
              setState(() {
                queryDocumentSnapshots = widget.documents.where((element) {
                  return element
                      .data()
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase());
                }).toList();
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                filled: true,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (() {
                    setState(() {
                      searchTextEditingController.text = "";
                      queryDocumentSnapshots = widget.documents;
                    });
                  }),
                ),
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Search Notifications",
                fillColor: Colors.white70),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                
              });
            },
            child: CardSliverListView(
              items: queryDocumentSnapshots,
              builder: (context, index) {
                QueryDocumentSnapshot document = queryDocumentSnapshots[index];
                
                switch (document.get("Name")) {
                  case "MaintenanceTicket":
                    return MaintenanceTicketNotificationCard(
                      document: document, tenant: widget.tenant, house: widget.house,
                  
                    );
                  case "DownloadLease":
                    return DownloadLeaseNotificationCard(
                      document: document,
                    );
                  case "Custom":
                    return CustomNotificationCard(document: document);
                  case "ApproveTenant":
                  return ApproveTenantNotificationCard(document: document);
                  default:
                    return Text(
                        "TODO: Make notification for event: ${document.get("Name")}");
                }
              },
              controller: ScrollController(),
            ),
          ),
        ),
      ],
    );
  }
}
