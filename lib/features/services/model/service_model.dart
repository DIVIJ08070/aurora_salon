class ServiceModel {
  final int id;
  final String serviceCode;
  final String name;
  final String category;
  final int durationMinutes;
  final double price;
  final String gender;
  final String description;
  final bool isAvailable;

  ServiceModel({
    required this.id,
    required this.serviceCode,
    required this.name,
    required this.category,
    required this.durationMinutes,
    required this.price,
    required this.gender,
    required this.description,
    required this.isAvailable,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int,
      serviceCode: json['service_code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      gender: json['gender'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
    );
  }
}
