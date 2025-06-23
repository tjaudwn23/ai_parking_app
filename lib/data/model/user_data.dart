class UserData {
  final String address;
  final double latitude;
  final String nickname;
  final double longitude;
  final String phoneNumber;
  final String addressDetail;
  final bool emailVerified;
  final bool phoneVerified;

  UserData({
    required this.address,
    required this.latitude,
    required this.nickname,
    required this.longitude,
    required this.phoneNumber,
    required this.addressDetail,
    required this.emailVerified,
    required this.phoneVerified,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      nickname: json['nickname'] ?? '',
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: json['phone_number'] ?? '',
      addressDetail: json['address_detail'] ?? '',
      emailVerified: json['email_verified'] ?? false,
      phoneVerified: json['phone_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'nickname': nickname,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'address_detail': addressDetail,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
    };
  }
}
