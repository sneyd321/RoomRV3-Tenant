

import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/business_logic/timestamp.dart';
import 'package:flutter/cupertino.dart';

class Comment  {

  String comment = "";
  String name = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  String profileURL = "";
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
  }

  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  void setProfileURL(String profileURL) {
    this.profileURL = profileURL;
  }
  
  


  String? validate() {
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
    profileURL = json["profileURL"] ?? "";
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'comment': comment,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      "profileURL": profileURL,
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
    profileURL = tenant.profileURL;
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
    profileURL = profileURL;
    name = "image";
  }


  ImageComment.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}