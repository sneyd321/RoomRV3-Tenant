import 'package:camera_example/business_logic/lease.dart';
import 'package:camera_example/business_logic/list_items/additional_term.dart';
import 'package:camera_example/business_logic/list_items/deposit.dart';
import 'package:flutter/cupertino.dart';

class House extends ChangeNotifier {

  int houseId = 0;
  String houseKey = "";
  String firebaseId = "";
  Lease lease = Lease();


  House();

  House.fromJson(Map<String, dynamic> json) {
    houseId = json["id"];
    houseKey = json["houseKey"];
    firebaseId = json["firebaseId"];
    lease = Lease.fromJson(json["lease"]);

  }

  void setFirebaseId(String firebaseId) {
    this.firebaseId = firebaseId;
    notifyListeners();
  }

  void setLease(Lease lease) {
    this.lease = lease;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      "firebaseId": firebaseId,
      "lease": lease.toJson()
    };
  }

  Deposit? getMaintenanceTicketDeductable() {
    for (var element in lease.rentDeposits) {
      if (element.name == "Maintenance Ticket Deductable"){
        return element;
      }
    }return null;
  }


}