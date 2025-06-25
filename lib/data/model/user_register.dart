class UserRegister {
  final String email;
  final String password;
  final String nickname;
  final String phoneNumber;
  final String address;
  final String addressDetail;
  final double latitude;
  final double longitude;
  final String name;

  UserRegister({
    required this.email,
    required this.password,
    required this.nickname,
    required this.phoneNumber,
    required this.address,
    required this.addressDetail,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
      'phone_number': phoneNumber,
      'address': address,
      'address_detail': addressDetail,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }
}
