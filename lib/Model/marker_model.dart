// ignore_for_file: public_member_api_docs, sort_constructors_first
class MarkerModel {
  final int id;
  final String markerId;
  final double latitude;
  final double longitude;

  MarkerModel({
    required this.id,
    required this.markerId,
    required this.latitude,
    required this.longitude,
  });

  // Convert a MarkerModel into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'markerId': markerId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Convert a Map object into a MarkerModel
  factory MarkerModel.fromMap(Map<String, dynamic> map) {
    return MarkerModel(
      id: map['id'],
      markerId: map['markerId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  MarkerModel copyWith({
    int? id,
    String? markerId,
    double? latitude,
    double? longitude,
  }) {
    return MarkerModel(
      id: id ?? this.id,
      markerId: markerId ?? this.markerId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
