// models/charger_type_model.dart
class ChargerType {
  final String recId;
  final String chargerType;
  final String chargerTypeImage;
  final String additionalInfo1;
  final int active;

  ChargerType({
    required this.recId,
    required this.chargerType,
    required this.chargerTypeImage,
    required this.additionalInfo1,
    required this.active,
  });

  factory ChargerType.fromJson(Map<String, dynamic> json) {
    return ChargerType(
      recId: json['recId'] ?? '',
      chargerType: json['chargerType'] ?? '',
      chargerTypeImage: json['chargerTypeImage'] ?? '',
      additionalInfo1: json['additionalInfo1'] ?? '',
      active: json['active'] ?? 0,
    );
  }
}
