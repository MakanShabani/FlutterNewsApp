class Entity {
  String id;
  DateTime createdAt;
  DateTime updatedAt;

  Entity({required this.id, required this.createdAt, required this.updatedAt});

  factory Entity.fromJson(Map<String, dynamic> parsedJson) => Entity(
        id: parsedJson['id'],
        createdAt: parsedJson['created_at'],
        updatedAt: parsedJson['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
