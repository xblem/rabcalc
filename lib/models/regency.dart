class Regency {
  final String id;
  final String name;

  Regency({required this.id, required this.name});

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Regency && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
