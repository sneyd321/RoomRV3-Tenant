import 'package:camera_example/business_logic/fields/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HouseKeyFormField extends StatefulWidget {

  final void Function(String? value) onSaved;
  final TextEditingController textEditingController;

   



  const HouseKeyFormField({Key? key, required this.textEditingController, required this.onSaved}) : super(key: key);

  @override
  State<HouseKeyFormField> createState() => HouseKeyFormFieldState();
}


class HouseKeyFormFieldState extends State<HouseKeyFormField> {

  
  String _enteredText = "";
  final int maxCharacterLength = 6;

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
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          counterText: '${widget.textEditingController.text.length.toString()}/$maxCharacterLength',
          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          prefixIcon: const Icon(Icons.key),
          labelText: "House Key",
          suffixIcon: IconButton(icon: const Icon(Icons.close), onPressed: () {
            widget.textEditingController.text = "";
            setState(() {
              
            });
          },)
        ),
        onSaved: (String? value) {
          widget.onSaved(value);
        },
         onChanged: (value) {
          setState(() {
            _enteredText = value;
          });
        },
        
        validator: (String? value) {
          return HouseKey(value!).validate();
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxCharacterLength),
          UpperCaseTextFormatter()
        ],
      ),
    );
  }
}


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}