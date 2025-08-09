import 'dart:io';

import 'package:read_quest/core/model/user_model.dart';
import 'package:uuid/uuid.dart';

class BookModel {
  final String id;
  final String title;
  final String? description;
  final String? cover;
  final UserModel? uploader;
  final String file;
  final String? accepted_at;

  BookModel({
    required this.id,
    required this.title,
    this.description,
    this.cover,
    this.uploader,
    required this.file,
    this.accepted_at,
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
      accepted_at: json['accepted_at'],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'title': title,
    'description': description,
    'cover': cover,
    'uploader': uploader?.uid,
    'file': file,
    'accepted_at': accepted_at,
  };

  BookModel copyWith({
    String? id,
    String? title,
    String? description,
    String? cover,
    UserModel? uploader,
    String? file,
    String? accepted_at,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cover: cover ?? this.cover,
      uploader: uploader ?? this.uploader,
      file: file ?? this.file,
      accepted_at: accepted_at ?? this.accepted_at,
    );
  }

  String generateID() {
    return Uuid().v4().replaceAll('-', '').substring(0, 8);
  }

  File getFile() => File(file);
  String getCurrentPHDateTime() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    final phTime = now.toIso8601String();

    return phTime;
  }
}
