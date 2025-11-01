/// 회원가입 요청 데이터 모델(UserRegister)
/// - 회원가입 시 서버로 전송할 사용자 정보를 담는 데이터 클래스입니다.
/// - 이메일, 비밀번호, 닉네임, 휴대폰 번호, 주소, 상세 주소, 좌표, 건물명 등을 포함합니다.
/// - toJson() 메서드를 통해 JSON 형태로 변환하여 API 요청에 사용합니다.

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
