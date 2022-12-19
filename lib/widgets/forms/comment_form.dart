import 'dart:convert';
import 'dart:typed_data';

import 'package:camera_example/widgets/Buttons/CallToActionButton.dart';
import 'package:camera_example/widgets/Buttons/SecondaryActionButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../business_logic/comment.dart';
import '../../../business_logic/fields/field.dart';
import '../../../business_logic/maintenance_ticket.dart';
import '../../../pages/additional_terms_page.dart';
import '../../../pages/comment_camera_page.dart';
import '../../Helper/BottomSheetHelper.dart';
import '../../business_logic/tenant.dart';
import '../../services/FirebaseConfig.dart';
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
    required this.maintenanceTicket,
    required this.houseKey,
    required this.tenant,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final TextEditingController commentTextEditingController =
      TextEditingController();
  late TextComment comment;
  ImagePicker picker = ImagePicker();
  XFile? image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int imageQuality = 100;

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
        Container(
          margin: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          child: CallToActionButton(
              text: "Add Image",
              onClick: () async {
                image = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                  imageQuality: imageQuality,
                );
                if (image != null) {
                  Uint8List imageBytes = await image!.readAsBytes();
                  
                  ImageComment comment = ImageComment.fromTenant(widget.tenant);
                  String encodedImage = base64Encode(imageBytes);
                  
                  if (encodedImage.length >= 1048487) {
                    imageQuality -= 20;
                    const snackBar = SnackBar(
                      content: Text('Image size is too large. Image quality reduced. Please try again.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  comment.setComment(encodedImage);
                  FirebaseConfiguration()
                      .setComment(widget.maintenanceTicket.firebaseId, comment);
                  Navigator.pop(context);
                }
              }),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          child: SecondaryActionButton(
              text: "Add Additional Term",
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdditionalTermsPage(
                            houseKey: widget.houseKey,
                            firebaseId: widget.maintenanceTicket.firebaseId,
                            tenant: widget.tenant,
                          )),
                );
              }),
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
