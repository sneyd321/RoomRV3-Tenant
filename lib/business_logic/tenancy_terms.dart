import 'package:camera_example/business_logic/partial_period.dart';
import 'package:camera_example/business_logic/rental_period.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TenancyTerms extends ChangeNotifier {
  RentalPeriod rentalPeriod = RentalPeriod("Fixed Term");
  String startDate = '';
  String rentDueDate = "First";
  String paymentPeriod = "Month";
  PartialPeriod partialPeriod = PartialPeriod();

  TenancyTerms();

  TenancyTerms.fromJson(Map<String, dynamic> json) {
    rentalPeriod = RentalPeriod.fromJson(json["rentalPeriod"]);
    startDate = json["startDate"];
    rentDueDate = json["rentDueDate"];
    paymentPeriod = json["paymentPeriod"];
    partialPeriod = PartialPeriod.fromJson(json["partialPeriod"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "rentalPeriod": rentalPeriod.toJson(),
      "startDate": startDate,
      "rentDueDate": rentDueDate,
      "paymentPeriod": paymentPeriod,
      "partialPeriod": partialPeriod.toJson()
    };
  }

  String getDateRentIsDue() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('EEEE MMMM dd yyyy');
    switch (rentDueDate) {
      case "First": 
        return formatter.format(DateTime(now.year, now.month + 1, 1));
      case "Second": 
        return formatter.format(DateTime(now.year, now.month + 1, 2));
      case "Last": 
        return formatter.format(DateTime(now.year, now.month + 2, 0));
      default:
        return formatter.format(now);
    }
  }

  int getLastDayInMonth() {
    DateTime now = DateTime.now();
    int days = DateTime(now.year, now.month + 2, 0).day;
     switch (rentDueDate) {
      case "First": 
        return days + 1;
      case "Second": 
        return days + 2;
      case "Last": 
        return days;
        
      default:
        return 0;
    }
  }

  int getDaysUntilRentIsDue() {
    DateTime now = DateTime.now();
     switch (rentDueDate) {
      case "First": 
        return DateTime(now.year, now.month + 1, 1).difference(now).inDays;
      case "Second": 
        return DateTime(now.year, now.month + 1, 2).difference(now).inDays;
      case "Last": 
        return DateTime(now.year, now.month + 1, 0).difference(now).inDays;
      default:
        return 0;
    }
  }


  String getDateRange() {
    if (rentalPeriod.endDate.isNotEmpty) {
      return "$startDate - ${rentalPeriod.endDate}";
    }
    return "$startDate - ${rentalPeriod.rentalPeriod}";
  }

  void setStartDate(String startDate) {
    this.startDate = startDate;
    notifyListeners();
  }

  void setRentalPeriod(RentalPeriod rentalPeriod) {
    this.rentalPeriod = rentalPeriod;
    notifyListeners();
  }

  void setPartialPeriod(PartialPeriod partialPeriod) {
    this.partialPeriod = partialPeriod;
  }

  void setRentDueDate(String rentDueDate) {
    this.rentDueDate = rentDueDate;
    notifyListeners();
  }

  void setPaymentPeriod(String paymentPeriod) {
    this.paymentPeriod = paymentPeriod;
    notifyListeners();
  }
}
