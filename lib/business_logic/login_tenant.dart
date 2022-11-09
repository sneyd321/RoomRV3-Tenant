class LoginTenant {

  String email = "";
  String password = "";
  String houseKey = "";
  String deviceId = "";

  LoginTenant();

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "houseKey": houseKey,
      "deviceId": deviceId
    };
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setHouseKey(String houseKey) {
    this.houseKey = houseKey;
  }

  void setDeviceId(String deviceId) {
    this.deviceId = deviceId;
  }




}