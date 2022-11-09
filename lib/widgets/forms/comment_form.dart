

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../business_logic/comment.dart';
import '../../../business_logic/fields/field.dart';
import '../../../business_logic/maintenance_ticket.dart';
import '../../../pages/additional_terms_page.dart';
import '../../../pages/comment_camera_page.dart';
import '../../Helper/BottomSheetHelper.dart';
import '../../business_logic/tenant.dart';
import '../Buttons/PrimaryButton.dart';
import '../Buttons/SecondaryButton.dart';
import '../form_fields/SimpleFormField.dart';

class CommentForm extends StatefulWidget {
  final void Function(BuildContext context, TextComment comment) onSend;
  final MaintenanceTicket maintenanceTicket;
  final String houseKey;
  final Tenant tenant;
  const CommentForm({
    Key? key,
    required this.onSend,
    required this.maintenanceTicket, required this.houseKey, required this.tenant,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final TextEditingController commentTextEditingController =
      TextEditingController();
  late TextComment comment;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comment = TextComment.fromTenant(widget.tenant);
  }

  void onOpenCommentTypes() {
    BottomSheetHelper(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PrimaryButton(Icons.add_a_photo, "Add Image", (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommentCameraPage(maintenanceTicket: widget.maintenanceTicket, tenant: widget.tenant)),
          );
        }),
        SecondaryButton(Icons.assignment, "Add Additional Term", (context) {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdditionalTermsPage(houseKey: widget.houseKey, firebaseId: widget.maintenanceTicket.firebaseId, tenant: widget.tenant,)),
          );
        }),
        ElevatedButton(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8, left: 8),
              child: IconButton(
                onPressed: onOpenCommentTypes,
                icon: const Icon(Icons.add_box),
              ),
            ),
            Expanded(
              child: SimpleFormField(
                  label: "Comment",
                  icon: Icons.comment,
                  textEditingController: commentTextEditingController,
                  onSaved: (value) {
                    comment.setComment(value!);
                  },
                  onValidate: (value) {
                    return CommentField(value!).validate();
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8, right: 8),
              child: IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      commentTextEditingController.text = "";
                    });
                    widget.onSend(context, comment);
                  }
                },
                icon: const Icon(Icons.send),
              ),
            )
          ],
        ));
  }
}
