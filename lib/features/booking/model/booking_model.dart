class BookingRequest {
  final int customerId;
  final int stylistId;
  final String appointmentDate;
  final String startTime;
  final List<int> serviceIds;
  final String? notes;

  BookingRequest({
    required this.customerId,
    required this.stylistId,
    required this.appointmentDate,
    required this.startTime,
    required this.serviceIds,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'customerId': customerId,
    'stylistId': stylistId,
    'appointmentDate': appointmentDate,
    'startTime': startTime,
    'serviceIds': serviceIds,
    'notes': notes,
  };
}

class TimeSlotModel {
  final int id;
  final String startTime;
  final String endTime;
  final String status;

  TimeSlotModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.status = 'available',
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] as int? ?? 0,
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      status: json['slot_status'] as String? ?? 'available',
    );
  }
}
