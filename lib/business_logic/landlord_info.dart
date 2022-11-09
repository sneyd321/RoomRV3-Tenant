import 'package:camera_example/business_logic/list_items/contact.dart';
import 'package:camera_example/business_logic/list_items/email.dart';
import 'package:flutter/cupertino.dart';


class LandlordInfo extends ChangeNotifier {
  String fullName = "";
  bool receiveDocumentsByEmail = true;
  List<EmailInfo> emails = [];
  bool contactInfo = true;
  List<Contact> contacts = [];

  LandlordInfo();

  LandlordInfo.fromJson(Map<String, dynamic> json) {
    fullName = json["fullName"];
    receiveDocumentsByEmail = json["receiveDocumentsByEmail"];
    emails = json["emails"].map<EmailInfo>((json)=> EmailInfo.fromJson(json)).toList();
    contactInfo = json["contactInfo"];
    contacts = json["contacts"].map<Contact>((json) => Contact.fromJson(json)).toList();
  }


  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "receiveDocumentsByEmail": receiveDocumentsByEmail,
      "emails": emails.map((EmailInfo email) => email.toJson()).toList(),
      "contactInfo": contactInfo,
      "contacts": contacts.map((Contact contact) => contact.toJson()).toList()
    };
    
  }

  void setFullName(String fullName) {
    this.fullName = fullName;
    notifyListeners();
  }

  void setReceiveDocumentsByEmail(bool receiveDocumentsByEmail) {
    this.receiveDocumentsByEmail = receiveDocumentsByEmail;
    notifyListeners();
  }

  void addEmail(String email) {
    emails.add(EmailInfo(email));
    notifyListeners();
  }

  void setContactInfo(bool contactInfo) {
    this.contactInfo = contactInfo;
    notifyListeners();
  }

  void addContactInfo(String contactInfo) {
    contacts.add(Contact(contactInfo));
    notifyListeners();
  }




}