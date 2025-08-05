import 'dart:convert';

class AppwriteDocument {
  String? id;
  String? updatedAt;
  String? createdAt;
  Map<String, dynamic> data;

  AppwriteDocument({
    this.id,
    this.updatedAt,
    this.createdAt,
    required this.data,
  });

  // Factory constructor to create an AppwriteDocument from a Map
  factory AppwriteDocument.fromMap(Map<String, dynamic> map) {
    return AppwriteDocument(
      id: map['\$id'] as String?,
      updatedAt: map['\$updatedAt'] as String?,
      createdAt: map['\$createdAt'] as String?,
      data: Map<String, dynamic>.from(map['data'] ?? {}),
    );
  }

  // Convert AppwriteDocument to Map
  Map<String, dynamic> toMap() {
    return {
      '\$id': id,
      '\$updatedAt': updatedAt,
      '\$createdAt': createdAt,
      'data': data,
    };
  }

  // Optional: Convert to JSON String
  String toJson() {
    return json.encode(toMap());
  }

  // Optional: Convert from JSON String
  factory AppwriteDocument.fromJson(String jsonStr) {
    return AppwriteDocument.fromMap(json.decode(jsonStr));
  }
}
