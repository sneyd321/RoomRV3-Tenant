import 'package:camera_example/graphql/graphql_client.dart';
import 'package:camera_example/widgets/Navigation/bottom_nav_bar.dart';
import 'package:camera_example/widgets/Navigation/navigation.dart';
import 'package:camera_example/widgets/builders/notifications_limit.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../business_logic/house.dart';
import '../business_logic/tenant.dart';
import '../graphql/query_helper.dart';

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
  Widget bottomNavigationBar = CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout)),
          ),
          body: QueryHelper(
            isList: false,
            onComplete: (json) {
              if (json == null) return const CircularProgressIndicator();
              House house = House.fromJson(json);

              return Column(
                children: [
                  Expanded(
                      child: NotificationLimit(
                          house: house, tenant: widget.tenant)),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
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
                            String? result = await Navigation()
                                .navigateToCreateMaintenanceTicketPage(
                                    context,
                                    image,
                                    widget.house.houseKey,
                                    widget.tenant);
                            if (result != null) {
                              const snackBar = SnackBar(
                                content: Text(
                                    'Maintenance Ticket Uploaded Successfully! You will recieve a notification here when completed.'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        label: const Text("Report Maintenance Ticket"),
                        icon: const Icon(Icons.add),
                      )),
                  BottomNavBar(tenant: widget.tenant, house: house)
                ],
              );
            },
            queryName: 'getHouse',
            variables: {"houseKey": widget.house.houseKey},
          ),
        ),
      ),
    );
  }
}
