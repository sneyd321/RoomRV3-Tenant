

import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/business_logic/timestamp.dart';
import 'package:flutter/cupertino.dart';

class Comment extends ChangeNotifier {

  String comment = "";
  String name = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  final Timestamp timestamp = Timestamp();

  String getFullName() {
    return "$firstName $lastName";
  }

  String getCurrentTime() {
    return timestamp.getCurrentTimestamp();
  }

  Comment();

  void setComment(String comment) {
    this.comment = comment;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setFirstName(String firstName) {
    this.firstName = firstName;
    notifyListeners();
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
    notifyListeners();
  }
  
  


  String? validate() {
    print("Inside validate");
     if (comment.length > 140) {
      return "Please enter a comment shorter than 140 characters";
    }
    if (comment.isEmpty) {
      return "Please enter a comment.";
    }
    return null;
  }

  Comment.fromJson(Map<String, dynamic> json) {
    
    comment = json["comment"];
    name = json["name"];
    email = json["email"];
    firstName = json["firstName"];
    lastName = json["lastName"];
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'comment': comment,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      "timestamp": timestamp.getCurrentDateTime()
  };
}

class TextComment extends Comment {


  TextComment() : super() {
    name = "text";
  }

  TextComment.fromTenant(Tenant tenant) {
    firstName = tenant.firstName;
    lastName = tenant.lastName;
    email = tenant.email;
    name = "text";
  }

  TextComment.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}


class ImageComment extends Comment {
  ImageComment() : super() {
    name = "image";
  }

   ImageComment.fromTenant(Tenant tenant) {
    firstName = tenant.firstName;
    lastName = tenant.lastName;
    email = tenant.email;
    name = "image";
  }


  ImageComment.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}