import 'package:camera_example/business_logic/maintenance_ticket.dart';
import 'package:camera_example/pages/comments_page.dart';
import 'package:camera_example/pages/dashboard_page.dart';
import 'package:camera_example/pages/more_page.dart';
import 'package:camera_example/pages/payments_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../business_logic/house.dart';
import '../../business_logic/tenant.dart';
import '../../pages/create_maintenance_ticket_page.dart';
import '../../pages/edit_profile_page.dart';
import '../../pages/notification_page.dart';
import '../../pages/profile_page.dart';

class Navigation {
  void navigateToCommentsPage(BuildContext context, Tenant tenant,
      String houseKey, int maintenanceTicketId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CommentsPage(
                tenant: tenant,
                houseKey: houseKey,
                maintenanceTicketId: maintenanceTicketId,
              )),
    );
  }

  void navigateToMorePage(BuildContext context, House house, Tenant tenant) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MorePage(house: house, tenant: tenant)));
  }

  Future<String?> navigateToCreateMaintenanceTicketPage(
      BuildContext context, XFile? image, String houseKey, Tenant tenant) async {
    return Navigator.push<String>(
        context,
        MaterialPageRoute(
            builder: (context) => CreateMaintenanceTicketPage(
                file: image!, houseKey: houseKey, tenant: tenant)));
  }

  void navigateToProfilePage(BuildContext context, Tenant tenant, House house) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage(
                tenant: tenant,
                house: house,
              )),
    );
  }

  void navigateToNotificationsPage(
      BuildContext context, House house, Tenant tenant) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NotificationPage(
                house: house,
                tenant: tenant,
              )),
    );
  }

  void navigateToPaymentsPage(BuildContext context, House house) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PaymentsPage(
                house: house,
              )),
    );
  }

  Future<bool?> navigateToDashboardPage(
      BuildContext context, Tenant tenant, House house) async {
    return await Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardPage(
                  tenant: tenant,
                  house: house,
                )));
  }

  Future<Tenant?> navigateToEditProfilePage(
      BuildContext context, Tenant tenant) async {
    return await Navigator.push<Tenant>(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(tenant: tenant)));
  }
}
