class UserModel {
  String name;
  String email;
  String address;
  String phone;

  UserModel({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
  });

  // CONVERT THE JSON TO OBJECT MODEL
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json["name"] ?? "User",
        email: json["email"] ?? "",
        address: json["address"] ?? "",
        phone: json["phone"] ?? "");
  }
}
