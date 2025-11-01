/// 비밀번호 변경 요청 데이터 모델(ChangePasswordRequest)
/// - 비밀번호 변경 API 요청 시 사용하는 데이터 클래스입니다.
/// - 이메일, 현재 비밀번호, 새 비밀번호를 포함합니다.
/// - toJson() 메서드를 통해 JSON 형태로 변환하여 API 요청에 사용합니다.

class ChangePasswordRequest {
  final String email;
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'current_password': currentPassword,
      'new_password': newPassword,
    };
  }
}
