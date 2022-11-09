import 'package:camera_example/business_logic/list_items/detail.dart';
import 'package:flutter/cupertino.dart';


abstract class Service extends ChangeNotifier {
  String name = "";
  bool isIncludedInRent = false;
  List<Detail> details = [];

  Service();


  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "isIncludedInRent": isIncludedInRent,
      "details": details.map((Detail detail) => detail.toJson()).toList()
    };
    
  }

  void addDetail(String detail) {
    details.add(Detail(detail));
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setIncludedInRent(bool value) {
    isIncludedInRent = value;
    notifyListeners();
  }
}

abstract class PayPerUseService extends Service {
  bool isPayPerUse = false;


  PayPerUseService() : super();

  PayPerUseService.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    isIncludedInRent = json["isIncludedInRent"];
    isPayPerUse = json["isPayPerUse"] ?? false;
    details = json["details"].map<Detail>((json) => Detail.fromJson(json)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "isIncludedInRent": isIncludedInRent,
      "isPayPerUse": isPayPerUse,
      "details": details.map((detail) => detail).toList()
    };
    
  }

  void setPayPerUse(bool value) {
    isPayPerUse = value;
    notifyListeners();
  }

  
}

class GasService extends PayPerUseService {
  GasService() {
    name = "Gas";
    isIncludedInRent = false;
    isPayPerUse = false; 
  }
  
}

class AirConditioningService extends PayPerUseService {
  AirConditioningService() {
    name = "Air Conditioning";
    isIncludedInRent = false;
    isPayPerUse = false;
  }
}

class AdditionalStorageSpace extends PayPerUseService {
  AdditionalStorageSpace() {
    name = "Additional Storage Space";
    isIncludedInRent = false;
    isPayPerUse = false;
  }
}

class OnSiteLaundry extends PayPerUseService {
  OnSiteLaundry() {
    name = "On-Site Laundry";
    isIncludedInRent = false;
    isPayPerUse = false;
  }
}

class GuestParking extends PayPerUseService {
  GuestParking() {
    name = "Guest Parking";
    isIncludedInRent = false;
    isPayPerUse = false;
  }
}

class CustomService extends PayPerUseService{

  CustomService(String name) : super() {
    this.name = name;
  }
  CustomService.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}
