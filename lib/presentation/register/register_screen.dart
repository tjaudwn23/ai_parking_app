import 'package:ai_parking/data/data_source/auth_api.dart';
import 'package:ai_parking/data/model/user_register.dart';
import 'package:ai_parking/presentation/common/custom_text_field.dart';
import 'package:ai_parking/presentation/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpostal/kpostal.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  final AuthApi _authApi = AuthApi();
  bool _isLoading = false;

  double? _latitude;
  double? _longitude;
  bool _isVerificationCodeSent = false;
  bool _isVerified = false;
  bool _isSignUpButtonEnabled = false;
  String? _passwordErrorMessage;
  String? _nicknameErrorMessage;
  String? _idErrorMessage;

  @override
  void initState() {
    super.initState();
    _idController.addListener(_updateSignUpButtonState);
    _nicknameController.addListener(_updateSignUpButtonState);
    _passwordController.addListener(_updateSignUpButtonState);
    _passwordConfirmController.addListener(_updateSignUpButtonState);
    _addressController.addListener(_updateSignUpButtonTapped);
    _phoneController.addListener(_updateSignUpButtonState);
    _verificationCodeController.addListener(_updateSignUpButtonState);
  }

  @override
  void dispose() {
    _idController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _addressController.removeListener(_updateSignUpButtonTapped);
    _addressController.dispose();
    _addressDetailController.dispose();
    _phoneController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  void _updateSignUpButtonTapped() {
    _updateSignUpButtonState();
  }

  void _updateSignUpButtonState() {
    setState(() {
      final allFieldsFilled =
          _idController.text.isNotEmpty &&
          _nicknameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordConfirmController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _verificationCodeController.text.isNotEmpty;

      final idIsValid = _isEmailValid(_idController.text);
      if (_idController.text.isNotEmpty) {
        if (!idIsValid) {
          _idErrorMessage = '올바른 이메일 형식이 아닙니다.';
        } else {
          _idErrorMessage = null;
        }
      } else {
        _idErrorMessage = null;
      }

      final nicknameIsValid = _nicknameController.text.length >= 2;
      if (_nicknameController.text.isNotEmpty) {
        if (!nicknameIsValid) {
          _nicknameErrorMessage = '닉네임은 2자 이상이어야 합니다.';
        } else {
          _nicknameErrorMessage = null;
        }
      } else {
        _nicknameErrorMessage = null;
      }

      final passwordIsValid = _isPasswordValid(_passwordController.text);
      final passwordsMatch =
          _passwordController.text == _passwordConfirmController.text;

      if (_passwordController.text.isNotEmpty) {
        if (!passwordIsValid) {
          _passwordErrorMessage = '8자 이상, 대/소문자를 포함해야 합니다.';
        } else if (!passwordsMatch) {
          _passwordErrorMessage = '비밀번호가 일치하지 않습니다.';
        } else {
          _passwordErrorMessage = null;
        }
      } else {
        _passwordErrorMessage = null;
      }

      _isSignUpButtonEnabled =
          allFieldsFilled &&
          idIsValid &&
          nicknameIsValid &&
          passwordIsValid &&
          passwordsMatch &&
          _isVerified;
    });
  }

  bool _isEmailValid(String email) {
    // Basic email regex
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    // 8자 이상, 대문자 및 소문자 포함
    final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  Future<void> _signUp() async {
    if (!_isSignUpButtonEnabled || _isLoading) return;

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('주소를 먼저 검색해주세요.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = UserRegister(
      email: _idController.text,
      password: _passwordController.text,
      nickname: _nicknameController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      addressDetail: _addressDetailController.text,
      latitude: _latitude!,
      longitude: _longitude!,
    );

    try {
      final message = await _authApi.signUp(user);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('회원가입 중 오류가 발생했습니다: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원가입',
          style: GoogleFonts.inter(
            color: const Color(0xFF000000),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(hintText: '아이디', controller: _idController),
                    if (_idErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _idErrorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: '닉네임',
                      controller: _nicknameController,
                    ),
                    if (_nicknameErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _nicknameErrorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: '비밀번호',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: '비밀번호 확인',
                      obscureText: true,
                      controller: _passwordConfirmController,
                    ),
                    if (_passwordErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _passwordErrorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: '집 주소 (터치하여 검색)',
                      controller: _addressController,
                      readOnly: true,
                      onTap: () async {
                        print('주소 검색창을 탭했습니다.');
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KpostalView(
                              kakaoKey: 'e513f614570c5df20937c7c0feb56f55',
                              callback: (Kpostal result) {
                                print(
                                  '주소: ${result.address}, 위도: ${result.latitude}, 경도: ${result.longitude}',
                                );
                                setState(() {
                                  _addressController.text = result.address;
                                  _latitude = result.latitude;
                                  _longitude = result.longitude;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: '동/호수 (상세주소 입력)',
                      controller: _addressDetailController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: '휴대폰 번호',
                            controller: _phoneController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: 실제 SMS 발송 API 호출 로직 추가 필요
                            setState(() {
                              _isVerificationCodeSent = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF29A645),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                          ),
                          child: Text(
                            '인증번호 발송',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isVerificationCodeSent)
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: '인증번호 6자리 입력',
                              controller: _verificationCodeController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: 실제 인증번호 검증 로직 추가
                              setState(() {
                                _isVerified = true;
                              });
                              _updateSignUpButtonState();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF29A645),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                            ),
                            child: Text(
                              '인증하기',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isSignUpButtonEnabled ? _signUp : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSignUpButtonEnabled
                            ? const Color(0xFF0066CC)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              '회원가입',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
