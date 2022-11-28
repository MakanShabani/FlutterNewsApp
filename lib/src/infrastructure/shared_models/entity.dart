class Entity {
  String id;
  DateTime createdAt;
  DateTime updatedAt;

  Entity({required this.id, required this.createdAt, required this.updatedAt});

  factory Entity.fromJson(Map<String, dynamic> parsedJson) => Entity(
        id: parsedJson['id'],
        createdAt: DateTime.parse(parsedJson['created_at']),
        updatedAt: DateTime.parse(parsedJson['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toString(),
        'updated_at': updatedAt.toString(),
      };
}
