class User {
  int userId;
  String name;
  String phoneNo;
  String email;
  String dob;
  String accessToken;
  int isPhoneVerified;

  User(
      {this.userId,
      this.name,
      this.phoneNo,
      this.email,
      this.dob,
      this.accessToken,
      this.isPhoneVerified});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    phoneNo = json['phone_no'];
    email = json['email'];
    dob = json['dob'];
    accessToken = json['access_token'];
    isPhoneVerified = json['is_phone_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['phone_no'] = this.phoneNo;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['access_token'] = this.accessToken;
    data['is_phone_verified'] = this.isPhoneVerified;
    return data;
  }
}
