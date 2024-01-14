import 'dart:convert';

import 'package:uuid/uuid.dart';

class Note {
  Note({
    String? id,
    required this.title,
    required this.content,
    required this.createdAt,
    // this.updatedAt,
    // this.isDone = false,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

//TODO: support later
// final DateTime? updatedAt;
// final bool isDone;

  Map<String, String> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'created_at': createdAt.toIso8601String(),
        // 'updated_at': updatedAt?.toIso8601String(),
        // 'is_done': isDone.toString(),
      };

  String toJson() => json.encode(toMap());

  static Note fromMap(Map<String, dynamic> map) => Note(
        id: map["id"] as String,
        title: map["title"]! as String,
        content: map["content"]! as String,
        createdAt: DateTime.parse(map["created_at"]! as String),
        // updatedAt: map["updated_at"] != null ? DateTime.parse(map["updated_at"]!as String) : null,
        // isDone: (map["is_done"] as bool) == "true",
      );

  static Note fromJson(String j) => Note.fromMap(json.decode(j));
}
