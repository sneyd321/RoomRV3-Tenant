import 'package:camera_example/graphql/query_helper.dart';
import 'package:camera_example/pages/notification_page.dart';
import 'package:camera_example/services/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../business_logic/house.dart';
import '../business_logic/tenant.dart';
import 'dashboard_page.dart';

class TenantViewPager extends StatefulWidget {
  final String houseKey;
  final Tenant tenant;
  const TenantViewPager(
      {Key? key, required this.houseKey, required this.tenant})
      : super(key: key);

  @override
  State<TenantViewPager> createState() => _TenantViewPagerState();
}

class _TenantViewPagerState extends State<TenantViewPager> {
  final PageController controller = PageController();
  int index = 1;
  late Widget body;

  @override
  void initState() {
    super.initState();
    widget.tenant.setFirstName("Timmy");
    widget.tenant.setLastName("Tenant");
    widget.tenant.setEmail("a@s.com");
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: QueryHelper(
              variables: {"houseKey": widget.houseKey},
              queryName: "getHouse",
              onComplete: (json) {
                House house = json == null ? House() : House.fromJson(json);
                switch (index) {
                  case 0:
                    return NotificationPage(
                      house: house,
                      tenant: widget.tenant,
                    );
                  case 1:
                    return DashboardPage(house: house);
                  default:
                    return DashboardPage(house: house);
                }
              },
              isList: false),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_sharp),
                label: 'Notification Feed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
            ],
            currentIndex: index,
            selectedItemColor: Colors.blue,
            onTap: (index) {
              setState(() {
                this.index = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
