/// 건물(아파트 동) 관련 데이터 모델(building.dart)
/// 
/// Building 클래스:
/// - 아파트의 동(건물) 정보를 담는 클래스입니다.
/// - 동 ID, 이름, 아파트 ID, 주차 상태 등을 포함합니다.
/// 
/// ParkingStatus 클래스:
/// - 건물의 주차 상태 정보를 담는 클래스입니다 (Building 내부용).
/// - 총 주차 공간과 비어있는 공간 수를 포함합니다.
/// 
/// BuildingListResponse 클래스:
/// - 건물 목록 API 응답을 담는 클래스입니다.
/// - 아파트 ID와 해당 아파트의 동 목록을 포함합니다.

class Building {
  final int id;
  final String apartmentId;
  final String name;
  final String createdAt;
  final String buildingId;
  final ParkingStatus? parkingStatus;

  Building({
    required this.id,
    required this.apartmentId,
    required this.name,
    required this.createdAt,
    required this.buildingId,
    this.parkingStatus,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      apartmentId: json['apartment_id'],
      name: json['name'],
      createdAt: json['created_at'],
      buildingId: json['building_id'],
      parkingStatus: json['parking_status'] != null
          ? ParkingStatus.fromJson(json['parking_status'])
          : null,
    );
  }
}

class ParkingStatus {
  final int totalSpaces;
  final int availableSpaces;

  ParkingStatus({required this.totalSpaces, required this.availableSpaces});

  factory ParkingStatus.fromJson(Map<String, dynamic> json) {
    return ParkingStatus(
      totalSpaces: json['total_spaces'],
      availableSpaces: json['available_spaces'],
    );
  }
}

class BuildingListResponse {
  final String apartmentId;
  final List<Building> buildings;

  BuildingListResponse({required this.apartmentId, required this.buildings});

  factory BuildingListResponse.fromJson(Map<String, dynamic> json) {
    return BuildingListResponse(
      apartmentId: json['apartment_id'],
      buildings: (json['buildings'] as List)
          .map((e) => Building.fromJson(e))
          .toList(),
    );
  }
}
