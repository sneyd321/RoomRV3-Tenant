import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../business_logic/field.dart';


class EmailFormField extends StatefulWidget {

  final void Function(Email value) onSaved;
  final TextEditingController textEditingController;

   



  const EmailFormField({Key? key, required this.textEditingController, required this.onSaved}) : super(key: key);

  @override
  State<EmailFormField> createState() => EmailFormFieldState();
}


class EmailFormFieldState extends State<EmailFormField> {

  final int maxCharacterLength = 255;

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 0, top: 8),
      child: TextFormField(
        controller: widget.textEditingController,
        maxLength: maxCharacterLength,
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          counterText: '${widget.textEditingController.text.length.toString()}/$maxCharacterLength',
          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          prefixIcon: const Icon(Icons.email),
          labelText: "Email",
        ),
        onSaved: (String? value) {
          Email email = Email(value!);
          widget.onSaved(email);
        },
         onChanged: (value) {
          setState(() { });
        },
        validator: (String? value) {
          return Email(value!).validate();
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxCharacterLength)
        ],
      ),
    );
  }
}
