import 'package:camera_example/business_logic/house.dart';
import 'package:camera_example/widgets/builders/notification_stream_builder.dart';
import 'package:flutter/material.dart';

import '../business_logic/list_items/deposit.dart';
import '../business_logic/tenant.dart';
import 'maintenance_ticket_camera_page.dart';

class NotificationPage extends StatelessWidget {
  final House house;
  final Tenant tenant;
  const NotificationPage({Key? key, required this.house, required this.tenant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: Container(
              height: 60,
              margin: const EdgeInsets.only(bottom: 16),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MaintenanceTicketCamera(
                                houseKey: house.houseKey,
                                tenant: tenant,
                              )));
                },
                label: const Text("Create Maintenance Ticket"),
                icon: const Icon(Icons.add),
              ),
            ),
            body: NotificationStreamBuilder(
              house: house,
              tenant: tenant,
            )));
  }
}
