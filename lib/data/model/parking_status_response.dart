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
