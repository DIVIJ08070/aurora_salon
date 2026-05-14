class AppointmentModel {
  final int id;
  final String appointmentNumber;
  final String date;
  final String startTime;
  final String endTime;
  final double totalAmount;
  final String status; // 'scheduled', 'completed', 'cancelled', 'no_show'
  final String stylistName;
  final String customerName;
  final String? notes;

  AppointmentModel({
    required this.id,
    required this.appointmentNumber,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
    required this.stylistName,
    required this.customerName,
    this.notes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Robust parsing for names (handles both flat and nested structures)
    String getNestedName(dynamic obj, String key, String fallback) {
      if (obj == null) return fallback;
      if (obj is String) return obj;
      if (obj is Map) return obj['name']?.toString() ?? obj[key]?.toString() ?? fallback;
      return fallback;
    }

    return AppointmentModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      appointmentNumber: json['appointment_number'] as String? ?? json['appointmentNumber'] as String? ?? '',
      date: (json['appointment_date'] as String? ?? json['appointmentDate'] as String? ?? '').split('T')[0],
      startTime: json['start_time'] as String? ?? json['startTime'] as String? ?? '',
      endTime: json['end_time'] as String? ?? json['endTime'] as String? ?? '',
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? json['totalAmount']?.toString() ?? '0') ?? 0.0,
      status: json['appointment_status'] as String? ?? json['appointmentStatus'] as String? ?? 'scheduled',
      stylistName: getNestedName(json['stylist'], 'name', json['stylist_name'] ?? 'Unknown Artist'),
      customerName: getNestedName(json['customer'], 'name', json['customer_name'] ?? 'Customer'),
      notes: json['notes'] as String?,
    );
  }
}
