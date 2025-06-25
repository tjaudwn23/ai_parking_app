import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/parking_status_response.dart';

class ParkingStatusApi {
  Future<ParkingStatusResponse> fetchParkingStatus(String buildingId) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/parking-status'),
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
