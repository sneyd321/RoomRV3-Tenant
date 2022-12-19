import 'dart:convert';
import 'dart:io';

import 'package:camera_example/business_logic/description.dart';
import 'package:camera_example/business_logic/fields/field.dart';
import 'package:camera_example/business_logic/maintenance_ticket.dart';
import 'package:camera_example/business_logic/sender.dart';
import 'package:camera_example/widgets/form_fields/SimpleFormField.dart';
import 'package:camera_example/widgets/form_fields/SimpleRadioGroup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../business_logic/tenant.dart';
import '../../graphql/mutation_helper.dart';
import '../buttons/CallToActionButton.dart';
import '../buttons/SecondaryActionButton.dart';

class MaintenanceTicketForm extends StatefulWidget {
  final XFile file;
  final Tenant tenant;
  final String houseKey;

  const MaintenanceTicketForm(
      {Key? key,
      required this.houseKey,
      required this.tenant,
      required this.file})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MaintenanceTicketFormState();
}

class _MaintenanceTicketFormState extends State<MaintenanceTicketForm> {
  MaintenanceTicket maintenanceTicket = MaintenanceTicket();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController descriptionTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    maintenanceTicket.setSender(Sender.fromTenant(widget.tenant));
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MutationHelper(
      mutationName: 'createMaintenanceTicket',
      onComplete: (json) {
        Navigator.pop(context);
      },
      builder: (runMutation) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height / 3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        width: 2,
                      ),
                    ),
                    child: kIsWeb
                        ? Image.network(widget.file.path)
                        : Image.file(File(widget.file.path)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Urgency:",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SimpleRadioGroup(
                      radioGroup: maintenanceTicket.urgency.name,
                      names: const ["Low", "Medium", "High"],
                      onSelected: (context, value) {
                        setState(() {
                          maintenanceTicket.setUrgency(value!);
                        });
                      },
                      isHorizontal: true),
                  SimpleFormField(
                    label: "Description",
                    icon: Icons.description,
                    textEditingController: descriptionTextEditingController,
                    onSaved: (value) {
                      maintenanceTicket.setDescription(Description(value!));
                    },
                    onValidate: (value) {
                      return DescriptionText(value!).validate();
                    },
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: CallToActionButton(text: "Report", onClick: () async{
                  if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        runMutation({
                          "houseKey": widget.houseKey,
                          "maintenanceTicket": maintenanceTicket.toJson(),
                          "image": base64Encode(await widget.file.readAsBytes())
                        });
                      }
                },),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: SecondaryActionButton(text: "Back", onClick: () {
                  Navigator.pop(context);
                },),
              )
              
            ],
          ),
        );
      },
    );
  }
}
