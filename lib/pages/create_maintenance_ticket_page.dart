
import 'package:camera_example/graphql/graphql_client.dart';
import 'package:camera_example/widgets/forms/maintenance_ticket_form.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../business_logic/tenant.dart';

class CreateMaintenanceTicketPage extends StatelessWidget {
  final XFile file;
  final String houseKey;
  final Tenant tenant;
  const CreateMaintenanceTicketPage({Key? key,  required this.houseKey, required this.tenant, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: MaintenanceTicketForm(file: file, houseKey: houseKey, tenant: tenant,)
              ),
            ),
          ),
    );
  }
}
