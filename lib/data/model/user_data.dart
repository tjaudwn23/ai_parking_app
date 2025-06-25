class UserData {
  final String email;
  final String address;
  final double latitude;
  final String nickname;
  final double longitude;
  final String phoneNumber;
  final String addressDetail;
  final bool emailVerified;
  final bool phoneVerified;
  final String name;

  UserData({
    required this.email,
    required this.address,
    required this.latitude,
    required this.nickname,
    required this.longitude,
    required this.phoneNumber,
    required this.addressDetail,
    required this.emailVerified,
    required this.phoneVerified,
    required this.name,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      nickname: json['nickname'] ?? '',
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: json['phone_number'] ?? '',
      addressDetail: json['address_detail'] ?? '',
      emailVerified: json['email_verified'] ?? false,
      phoneVerified: json['phone_verified'] ?? false,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'address': address,
      'latitude': latitude,
      'nickname': nickname,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'address_detail': addressDetail,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'name': name,
    };
  }
}
