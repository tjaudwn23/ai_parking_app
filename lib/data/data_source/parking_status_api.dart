/// 주차 상태 API 클래스(ParkingStatusApi)
/// - 주차 상태 관련 API 호출을 담당하는 데이터 소스 클래스입니다.
/// - fetchParkingStatus(): buildingId를 받아 해당 동의 현재 주차 상태와 30분 후 예측 상태를 가져옵니다.
/// - POST 요청으로 building_id를 전송하고 ParkingStatusResponse를 반환합니다.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/parking_status_response.dart';
import 'board_api.dart';

class ParkingStatusApi {
  Future<ParkingStatusResponse> fetchParkingStatus(String buildingId) async {
    final response = await http.post(
      Uri.parse(BASE_URL + '/api/parking-status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'building_id': buildingId}),
    );
    if (response.statusCode == 200) {
      return ParkingStatusResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load parking status');
    }
  }
}
