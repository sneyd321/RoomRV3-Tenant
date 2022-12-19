import 'package:camera_example/business_logic/tenancy_terms.dart';
import 'package:camera_example/business_logic/tenant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../../business_logic/house.dart';
import 'notification_search.dart';

class NotificationLimit extends StatefulWidget {
  final House house;
  final Tenant tenant;
  const NotificationLimit(
      {Key? key, required this.house, required this.tenant})
      : super(key: key);

  @override
  State<NotificationLimit> createState() => _NotificationLimitState();
}

class _NotificationLimitState extends State<NotificationLimit> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('House')
          .doc(widget.house.firebaseId)
          .collection("Tenant")
          .orderBy("dateCreated", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<QueryDocumentSnapshot> queryDocumentSnapshots =
            snapshot.data!.docs;
    
        return NotificationSearch(
            tenant: widget.tenant, documents: queryDocumentSnapshots);
      },
    );
  }
}
