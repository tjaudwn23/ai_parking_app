/// 주차 상태 API 클래스(ParkingStatusApi)
/// - 주차 상태 관련 API 호출을 담당하는 데이터 소스 클래스입니다.
/// - fetchParkingStatus(): buildingId를 받아 해당 동의 현재 주차 상태와 30분 후 예측 상태를 가져옵니다.
/// - POST 요청으로 building_id를 전송하고 ParkingStatusResponse를 반환합니다.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/parking_status_response.dart';
import 'board_api.dart';

class ParkingStatusApi {
  Future<ParkingStatusResponse> fetchParkingStatus(String buildingId) async {
    final uri = Uri.parse('$BASE_URL/api/parking-status');
    final requestBody = jsonEncode({'building_id': buildingId});

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] POST ${uri.toString()}');
    print('📤 요청 헤더: {\'Content-Type\': \'application/json\'}');
    print('📤 요청 바디: $requestBody');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] POST ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디 (길이: ${response.body.length}자):');

    // 긴 응답 바디를 여러 줄로 나누어 출력
    final responseBody = response.body;
    const chunkSize = 1000; // 한 번에 출력할 최대 문자 수

    if (responseBody.length <= chunkSize) {
      print(responseBody);
    } else {
      for (int i = 0; i < responseBody.length; i += chunkSize) {
        final end = (i + chunkSize < responseBody.length)
            ? i + chunkSize
            : responseBody.length;
        print(
          '[${i + 1}~$end/${responseBody.length}] ${responseBody.substring(i, end)}',
        );
      }
    }

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode == 200) {
      return ParkingStatusResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load parking status');
    }
  }
}
