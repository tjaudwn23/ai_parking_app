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
