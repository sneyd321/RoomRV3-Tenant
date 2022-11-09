import 'package:camera_example/business_logic/tenant.dart';

class Sender {
  String firstName = "";
  String lastName = "";
  String email = "";


  Sender();

  Sender.fromTenant(Tenant tenant) {
    firstName = tenant.firstName;
    lastName = tenant.lastName;
    email = tenant.email;
  }

  Sender.fromJson(Map<String, dynamic> json) {
    firstName = json["firstName"];
    lastName = json["lastName"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email
    };

  }


  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  void setEmail(String email) {
    this.email = email;
  }


}