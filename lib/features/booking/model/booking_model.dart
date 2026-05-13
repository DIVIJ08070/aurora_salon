class BookingRequest {
  final int customerId;
  final int stylistId;
  final String appointmentDate; // format: YYYY-MM-DD
  final String startTime; // format: HH:MM:SS
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
  
  TimeSlotModel({required this.id, required this.startTime, required this.endTime});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] as int? ?? 0,
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
    );
  }
}
