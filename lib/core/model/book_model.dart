import 'package:flutter/widgets.dart';
import 'package:read_quest/core/model/user_model.dart';

class BookModel {
  final String id;
  final String title;
  final String? description;
  final String? cover;
  final UserModel? uploader;
  final String file;

  BookModel({
    required this.id,
    required this.title,
    this.description,
    this.cover,
    this.uploader,
    required this.file,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      cover: json['cover'],
      uploader: json['uploader'] != null
          ? UserModel.fromMap(json['uploader'])
          : null,
      file: json['file'],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'title': title,
    'description': description,
    'cover': cover,
    'uploader': uploader?.uid,
    'file': file,
  };

  String generateID() {
    return '${UniqueKey()}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
