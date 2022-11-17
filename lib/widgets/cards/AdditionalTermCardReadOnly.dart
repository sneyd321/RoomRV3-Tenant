
import 'package:flutter/material.dart';


import '../../Helper/TextHelper.dart';
import '../../business_logic/comment.dart';
import '../../business_logic/list_items/additional_term.dart';
import '../../business_logic/list_items/detail.dart';
import '../../business_logic/tenant.dart';
import '../../services/FirebaseConfig.dart';
import '../listviews/CardSliverGenerator.dart';
import 'DetailCardReadOnly.dart';


class AdditionalTermCardReadOnly extends StatelessWidget {
  final AdditionalTerm additionalTerm;
  final String firebaseId;
  final Tenant tenant;

  const AdditionalTermCardReadOnly(
      {Key? key, required this.additionalTerm, required this.firebaseId, required this.tenant, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String term = additionalTerm.name;
        for (Detail detail in additionalTerm.details) {
          term += "\n${detail.detail}";
        }
        TextComment comment = TextComment.fromTenant(tenant);
        comment.setComment(term);
        FirebaseConfiguration().setComment(firebaseId, comment);
        
       
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Card(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.assignment),
            title: TextHelper(text: additionalTerm.name),
          ),
          CardSliverGenerator(
              shrinkWrap: true,
              items: additionalTerm.details
                  .map<String>((Detail detail) => detail.detail)
                  .toList(),
              generator: (index) {
                String detail = additionalTerm.details[index].detail;
                return DetailCardReadOnly(
                  detail: detail,
                );
              })
        ]),
      ),
    );
  }
}
