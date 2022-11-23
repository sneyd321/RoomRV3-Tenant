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


  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.logout),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.notifications),
                    text: "Notification Feed",
                  ),
                  Tab(
                    icon: Icon(Icons.dashboard),
                    text: "Dashboard",
                  ),
                ],
              ),
            ),
            body: QueryHelper(
                variables: {"houseKey": widget.houseKey},
                queryName: "getHouse",
                onComplete: (json) {
                  if (json != null) {
                    House house = House.fromJson(json);
                     return TabBarView(children: [
                    NotificationPage(
                      house: house,
                      tenant: widget.tenant,
                    ),
                    DashboardPage(house: house)
                  ]);
                  }
                  return const TabBarView(children: [CircularProgressIndicator(), CircularProgressIndicator()],);
                  
                 
                },
                isList: false),
           
          ),
        ),
      ),
    );
  }
}
