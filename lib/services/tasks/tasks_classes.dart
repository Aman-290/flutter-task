import 'package:flutter/material.dart';

class Task {
  final int id;
  String title;
  String description;
  DateTime timeStart;
  DateTime timeEnd;
  Color color;
  List<Color> gradientColors; // Added gradient colors
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.timeStart,
    required this.timeEnd,
    required this.color,
    required this.gradientColors, // Added gradient colors
  }) : isCompleted = false;
}

class Subject {
  String name;
  String iconAssetPath;
  List<Color> gradientColors;
  int numTasksLeft;

  Subject({required this.name, required this.gradientColors})
      : iconAssetPath = 'assets/icons/physics.png',
        numTasksLeft = 0;
}
