class CustomerModel {
  final int id;
  final String customerCode;
  final String name;
  final String phone;
  final String? email;

  CustomerModel({
    required this.id,
    required this.customerCode,
    required this.name,
    required this.phone,
    this.email,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int? ?? 0,
      customerCode: json['customer_code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_code': customerCode,
    'name': name,
    'phone': phone,
    'email': email,
  };
}
