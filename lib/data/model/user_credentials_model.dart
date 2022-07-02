class UserCredentialsModel {
  String? email;
  String? password;
  String? userName;
  DateTime? coupleAnniversary;
  DateTime? userEnrolledDate;
  String? coupleCode;

  UserCredentialsModel({
    this.email,
    this.password,
    this.userName,
    this.coupleAnniversary,
    this.coupleCode,
    this.userEnrolledDate,
  });

  factory UserCredentialsModel.fromJson(Map<String, dynamic> json) => UserCredentialsModel(
    userName: json["userName"],
    coupleAnniversary: DateTime.parse(json["coupleAnniversary"]),
    coupleCode: json["coupleCode"],
    userEnrolledDate: DateTime.parse(json["userEnrolledDate"]),
  );
}