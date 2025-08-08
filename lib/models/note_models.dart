import 'package:flutter/services.dart';

class NoteCardData {
  final int id;
  final String title;
  final String content;
  final String time;
  final DateTime updatedAt;
  final Color? color;

  NoteCardData({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.updatedAt,
    this.color,
  });
}
