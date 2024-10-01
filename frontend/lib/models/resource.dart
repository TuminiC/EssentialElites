class Resource {
  final String name;
  final String type;
  final String description;
  final String address;
  final String phone;

  Resource({
    required this.name,
    required this.type,
    required this.description,
    required this.address,
    required this.phone,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    print(json);
    return Resource(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}