import 'dart:convert';

Exercise exericiseFromJson(String str) => Exercise.fromJson(json.decode(str));

String exericiseToJson(Exercise data) => json.encode(data.toJson());

class Exercise {
  int id;
  String name;
  String imageUrl;
  String videoUrl;
  String description;
  int bodyPartId;

  Exercise({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.videoUrl,
    required this.description,
    required this.bodyPartId,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imageUrl: json["image_url"],
        videoUrl: json["video_url"],
        bodyPartId: json["body_part_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
        "video_url": videoUrl,
        "description": description,
        "body_part_id": bodyPartId,
      };

  @override
  String toString() {
    return 'Exercise{id: $id, name: $name, imageUrl: $imageUrl, videoUrl: $videoUrl, description: $description, bodyPartId: $bodyPartId}';
  }
}
