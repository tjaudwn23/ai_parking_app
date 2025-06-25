import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/building.dart';

class BuildingApi {
  Future<BuildingListResponse> fetchBuildings(String fullAddress) async {
    final uri = Uri.parse(
      'http://localhost:8000/api/apartments/buildings',
    ).replace(queryParameters: {'full_address': fullAddress});
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
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
      'http://localhost:8000/api/buildings',
    ).replace(queryParameters: {'apartment_id': apartmentId});
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Building.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load buildings');
    }
  }
}
