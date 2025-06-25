import 'package:flutter/foundation.dart';

class UserData {
  final String id;
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
  final String apartmentId;

  UserData({
    required this.id,
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
    required this.apartmentId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
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
      apartmentId: json['apartment_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'apartment_id': apartmentId,
    };
  }

  UserData copyWith({
    String? id,
    String? email,
    String? address,
    double? latitude,
    String? nickname,
    double? longitude,
    String? phoneNumber,
    String? addressDetail,
    bool? emailVerified,
    bool? phoneVerified,
    String? name,
    String? apartmentId,
  }) {
    return UserData(
      id: id ?? this.id,
      email: email ?? this.email,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      nickname: nickname ?? this.nickname,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressDetail: addressDetail ?? this.addressDetail,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      name: name ?? this.name,
      apartmentId: apartmentId ?? this.apartmentId,
    );
  }
}
