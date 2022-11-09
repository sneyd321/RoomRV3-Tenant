import 'package:flutter/cupertino.dart';

abstract class RentService extends ChangeNotifier {
  String name = "";
  String amount = "0.00";

  RentService();

  RentService.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    amount = json["amount"];
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "amount": amount};
  }

  void setAmount(String amount) {
    this.amount = amount;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

}

class CustomRentService extends RentService {
  CustomRentService(String name, String amount) : super() {
    this.name = name;
    this.amount = amount;
  }

   CustomRentService.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    amount = json["amount"];
   }
}
