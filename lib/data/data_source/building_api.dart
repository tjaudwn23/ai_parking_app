/// 건물(아파트 동) 관련 API 클래스(BuildingApi)
/// - 건물 정보 조회 관련 API 호출을 담당하는 데이터 소스 클래스입니다.
/// - fetchBuildings(): 전체 주소를 받아 해당 아파트의 동 목록을 가져옵니다.
/// - fetchAllBuildings(): apartmentId를 받아 해당 아파트의 모든 동 목록을 가져옵니다.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/building.dart';
import 'board_api.dart';

class BuildingApi {
  Future<BuildingListResponse> fetchBuildings(String fullAddress) async {
    final uri = Uri.parse(
      BASE_URL + '/api/apartments/buildings',
    ).replace(queryParameters: {'full_address': fullAddress});
    
    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] GET ${uri.toString()}');
    print('📤 요청 헤더: {\'Content-Type\': \'application/json\'}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] GET ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return BuildingListResponse.fromJson(data);
    } else {
      throw Exception('Failed to load buildings');
    }
  }

  /// 특정 아파트의 모든 동(건물) 리스트를 조회합니다.
  /// [apartmentId] : 아파트의 고유 ID
  Future<List<Building>> fetchAllBuildings(String apartmentId) async {
    final uri = Uri.parse(
      BASE_URL + '/api/buildings',
    ).replace(queryParameters: {'apartment_id': apartmentId});
    
    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] GET ${uri.toString()}');
    print('📤 요청 헤더: {\'Content-Type\': \'application/json\'}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] GET ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Building.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load buildings');
    }
  }
}
