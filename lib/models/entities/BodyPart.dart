import 'dart:convert';

class BodyPart {
  int id;
  String name;

  BodyPart({
    required this.id,
    required this.name,
  });

  factory BodyPart.fromJson(Map<String, dynamic> json) {
    return BodyPart(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'BodyPart(id: $id, name: $name)';
  }
}

