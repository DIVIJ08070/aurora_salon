class StylistModel {
  final int id;
  final String name;
  final String specialisation;
  final String workingDays;
  final String shiftStart;
  final String shiftEnd;
  final String stylistStatus;
  final String? imageUrl; // Added back for image support

  StylistModel({
    required this.id,
    required this.name,
    required this.specialisation,
    required this.workingDays,
    required this.shiftStart,
    required this.shiftEnd,
    required this.stylistStatus,
    this.imageUrl,
  });

  factory StylistModel.fromJson(Map<String, dynamic> json) {
    return StylistModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      specialisation: json['specialisation'] as String? ?? '',
      workingDays: json['working_days'] as String? ?? '',
      shiftStart: json['shift_start'] as String? ?? '',
      shiftEnd: json['shift_end'] as String? ?? '',
      stylistStatus: json['stylist_status'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['photo'] as String?,
    );
  }
}
