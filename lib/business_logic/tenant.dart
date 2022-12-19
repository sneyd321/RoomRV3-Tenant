
class Tenant {
  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String phoneNumber = "";
  String profileURL = "";
  String state = "";
  int houseId = 0;
  String deviceId = "";


  Tenant();

  Tenant.fromJson(Map<String, dynamic> json) {
    firstName = json["firstName"];
    lastName = json["lastName"];
    email = json["email"];
    phoneNumber = json["phoneNumber"];
    profileURL = json["profileURL"];
    state = json["state"];
    houseId = json["houseId"];
  }

  
  String getFullName() {
    return "$firstName $lastName";
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
      "email": email,
    };
  }



  Map<String, dynamic> toUpdateStateJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
    };
  }

  Map<String, dynamic> toTenantInput() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "profileURL": profileURL,
      "email": email,
    };
  }


  void setFirstName(String value) {
    firstName = value;
  }

  void setLastName(String value) {
    lastName = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void setEmail(String value) {
    email = value;
  }

  void setState(String state) {
    this.state = state;
  }

  void setPhoneNumber(String value) {
    phoneNumber = value;
  }

}