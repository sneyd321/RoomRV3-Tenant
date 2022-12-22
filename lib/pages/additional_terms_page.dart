
import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/graphql/query_helper.dart';
import 'package:camera_example/widgets/cards/AdditionalTermCardReadOnly.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../business_logic/house.dart';
import '../business_logic/list_items/additional_term.dart';
import '../graphql/graphql_client.dart';
import '../widgets/listviews/CardSliverListView.dart';

class AdditionalTermsPage extends StatefulWidget {
  final String houseKey;
  final String firebaseId;
  final Tenant tenant;
  const AdditionalTermsPage(
      {Key? key, required this.houseKey, required this.firebaseId, required this.tenant})
      : super(key: key);

  @override
  State<AdditionalTermsPage> createState() => _AdditionalTermsPageState();
}

class _AdditionalTermsPageState extends State<AdditionalTermsPage> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: QueryHelper(isList: false,
          queryName: "getHouse",
          variables: {
            "houseKey": widget.houseKey
          },
          
          onComplete: (json) {
              if (json == null) {
                return const CircularProgressIndicator();
              }
             House house = House.fromJson(json);
              return CardSliverListView(
                  items: house.lease.additionalTerms,
                  builder: (context, index) {
                    AdditionalTerm additionalTerm =
                        house.lease.additionalTerms[index];
                    return AdditionalTermCardReadOnly(
                      tenant: widget.tenant,
                        firebaseId: widget.firebaseId,
                        additionalTerm: additionalTerm);
                  },
                  controller: ScrollController());
            },)
          ),
        ),
      );
  }
}
