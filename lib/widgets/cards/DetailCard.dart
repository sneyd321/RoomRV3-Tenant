import 'package:flutter/material.dart';

import '../../Helper/TextHelper.dart';

class DetailCard extends StatelessWidget {
  final String detail;
  const DetailCard(
      {Key? key, required this.detail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.label),
        title: TextHelper(text: detail),
        
      ),
    );
  }
}
