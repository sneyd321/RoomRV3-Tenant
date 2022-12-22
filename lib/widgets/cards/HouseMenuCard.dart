
import 'dart:ui';

import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/graphql/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../business_logic/address.dart';
import '../../business_logic/house.dart';
import '../../graphql/mutation_helper.dart';


class HouseMenuCard extends StatefulWidget {
  final House house;
  final Tenant tenant;
  const HouseMenuCard({
    Key? key,
    required this.house,
    required this.tenant,
  }) : super(key: key);

  @override
  State<HouseMenuCard> createState() => _HouseMenuCardState();
}

class _HouseMenuCardState extends State<HouseMenuCard> {
  String parsePrimaryAddress(House house) {
    RentalAddress rentalAddress = house.lease.rentalAddress;
    String streetNumber = rentalAddress.streetNumber;
    String streetName = rentalAddress.streetName;
    return "$streetNumber $streetName";
  }

  String parseSecondaryAddress(House house) {
    RentalAddress rentalAddress = house.lease.rentalAddress;
    String city = rentalAddress.city;
    String province = rentalAddress.province;
    String postalCode = rentalAddress.postalCode;
    return "$city, $province $postalCode";
  }

  

  

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQLClient().getClient(),
      child: MutationHelper(
        onComplete: (json) {},
        mutationName: "signLease",
        builder: ((runMutation) {
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.hardEdge,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/house.jpg"),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  height: 200,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "House Key: ${widget.house.houseKey}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )),
                      Text(
                        parsePrimaryAddress(widget.house),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        parseSecondaryAddress(widget.house),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
