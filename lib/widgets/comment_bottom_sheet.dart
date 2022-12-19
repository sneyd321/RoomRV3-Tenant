
import 'package:flutter/material.dart';

import 'buttons/PrimaryButton.dart';
import 'buttons/SecondaryButton.dart';

class CommentBottomSheet extends StatelessWidget {
  const CommentBottomSheet({Key? key}) : super(key: key);

  void onAddPicture(BuildContext context) {}

  void onAddAdditionalTerm(BuildContext context) {
    print('add additional term');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PrimaryButton(Icons.add_a_photo, "Add Image", (context) {
          
        }),
        SecondaryButton(
            Icons.assignment, "Add Additional Term", onAddAdditionalTerm),
        ElevatedButton(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
