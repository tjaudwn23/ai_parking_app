/// 주차 상태 응답 데이터 모델(parking_status_response.dart)
/// 
/// ParkingStatus 클래스:
/// - 현재 주차 상태 정보를 담는 클래스입니다.
/// - 총 주차 공간, 사용 중인 공간, 비어있는 공간, 상세 정보, 이미지 URL 등을 포함합니다.
/// 
/// ParkingPrediction 클래스:
/// - 30분 후 예측 주차 상태 정보를 담는 클래스입니다.
/// - 예측 시간, 예측된 주차 공간 상태 등을 포함합니다.
/// 
/// ParkingStatusResponse 클래스:
/// - 주차 상태 API 응답을 담는 루트 클래스입니다.
/// - 현재 상태와 예측 상태를 함께 포함합니다.

class ParkingStatus {
  final String lastUpdate;
  final int totalSpaces;
  final int occupiedSpaces;
  final int availableSpaces;
  final List<dynamic> spaceDetails;
  final String? imageUrl;

  ParkingStatus({
    required this.lastUpdate,
    required this.totalSpaces,
    required this.occupiedSpaces,
    required this.availableSpaces,
    required this.spaceDetails,
    required this.imageUrl,
  });

  factory ParkingStatus.fromJson(Map<String, dynamic> json) {
    return ParkingStatus(
      lastUpdate: json['last_update'] ?? '',
      totalSpaces: json['total_spaces'] ?? 0,
      occupiedSpaces: json['occupied_spaces'] ?? 0,
      availableSpaces: json['available_spaces'] ?? 0,
      spaceDetails: json['space_details'] ?? [],
      imageUrl: json['image_url'],
    );
  }
}

class ParkingPrediction {
  final String predictionTimestamp;
  final int predictedOccupied;
  final int predictedAvailable;
  final List<dynamic> spacePredictions;
  final String? imageUrl;

  ParkingPrediction({
    required this.predictionTimestamp,
    required this.predictedOccupied,
    required this.predictedAvailable,
    required this.spacePredictions,
    required this.imageUrl,
  });

  factory ParkingPrediction.fromJson(Map<String, dynamic> json) {
    return ParkingPrediction(
      predictionTimestamp: json['prediction_timestamp'] ?? '',
      predictedOccupied: json['predicted_occupied'] ?? 0,
      predictedAvailable: json['predicted_available'] ?? 0,
      spacePredictions: json['space_predictions'] ?? [],
      imageUrl: json['image_url'],
    );
  }
}

class ParkingStatusResponse {
  final ParkingStatus? currentStatus;
  final ParkingPrediction? prediction30min;

  ParkingStatusResponse({
    required this.currentStatus,
    required this.prediction30min,
  });

  factory ParkingStatusResponse.fromJson(Map<String, dynamic> json) {
    return ParkingStatusResponse(
      currentStatus: json['current_status'] != null
          ? ParkingStatus.fromJson(json['current_status'])
          : null,
      prediction30min: json['prediction_30min'] != null
          ? ParkingPrediction.fromJson(json['prediction_30min'])
          : null,
    );
  }
}
