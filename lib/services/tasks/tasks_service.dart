import 'package:flutter/material.dart';
import 'package:studize_interview/services/tasks/tasks_classes.dart';
import 'package:studize_interview/services/tasks/tasks_exceptions.dart';

class TasksService {
  static Future<List<String>> getSubjectNameList() async {
    return ['Physics', 'Chemistry', 'Mathematics'];
  }

  static Future<List<Subject>> getSubjectList() async {
    return <Subject>[
      Subject(name: 'Physics', gradientColors: [
        Color.fromARGB(255, 115, 20, 52),
        Color.fromARGB(255, 234, 120, 112)
      ]),
      Subject(name: 'Chemistry', gradientColors: [
        Color.fromARGB(255, 31, 88, 114),
        Color.fromARGB(255, 108, 182, 243)
      ]),
      Subject(name: 'Mathematics', gradientColors: [
        Color.fromARGB(255, 64, 95, 29),
        Color.fromARGB(255, 121, 243, 125)
      ]),
      Subject(name: 'Biology', gradientColors: [
        Color.fromARGB(255, 109, 76, 28), // Lighter shade
        Color.fromARGB(255, 247, 196, 137), // Original color
      ]),
      Subject(name: 'Computer', gradientColors: [
        Color.fromARGB(255, 112, 15, 101), // Lighter shade
        Color.fromARGB(255, 251, 169, 236), // Original color
      ]),
    ];
  }

  static Future<List<Task>> getAllTasks() async {
    final DateTime now = DateTime.now();
    List<Task> taskList = <Task>[
      Task(
        id: 0,
        title: 'Mathematics',
        description: 'Complex Numbers Quiz',
        timeStart: now.add(const Duration(hours: 2)),
        timeEnd: now.add(const Duration(hours: 2)),
        color: Colors.green,
        gradientColors: [
          Color.fromARGB(255, 64, 95, 29),
          Color.fromARGB(255, 121, 243, 125)
        ], // Light to dark green
      ),
      Task(
        id: 1,
        title: 'Physics',
        description: 'Kinematics - Prepare Notes',
        timeStart: now.add(const Duration(hours: 2)), // Adjusted to 3
        timeEnd: now.add(const Duration(hours: 3)), // Adjusted to 4
        color: Colors.red,
        gradientColors: [
          Color.fromARGB(255, 115, 20, 52),
          Color.fromARGB(255, 234, 120, 112)
        ], // Light to dark red
      ),
      Task(
        id: 2,
        title: 'Chemistry',
        description: 'Isomerism - Prepare Notes',
        timeStart: now.add(const Duration(hours: 4)), // Adjusted to 5
        timeEnd: now.add(const Duration(hours: 5)), // Adjusted to 6
        color: Colors.blue,
        gradientColors: [
          Color.fromARGB(255, 31, 88, 114),
          Color.fromARGB(255, 108, 182, 243)
        ], // Light to dark blue
      ),
      Task(
        id: 3,
        title: 'Biology',
        description: 'Cell Structure - Prepare Notes',
        timeStart: now.add(const Duration(hours: 5)), // Adjusted to 7
        timeEnd: now.add(const Duration(hours: 6)), // Adjusted to 8
        color: const Color.fromARGB(255, 175, 129, 76),
        gradientColors: [
          Color.fromARGB(255, 109, 76, 28), // Lighter shade
          Color.fromARGB(255, 247, 196, 137), // Original color
        ], // Light to dark brown
      ),
      Task(
        id: 4,
        title: 'Computer',
        description: 'Data Structure - Prepare Notes',
        timeStart: now.add(const Duration(hours: 5)), // Adjusted to 7
        timeEnd: now.add(const Duration(hours: 6)), // Adjusted to 8
        color: const Color.fromARGB(255, 0, 255, 213),
        gradientColors: [
          Color.fromARGB(255, 112, 15, 101), // Lighter shade
          Color.fromARGB(255, 251, 169, 236), // Original color
        ],
      ),
    ];
    return taskList;
  }

  /// Returns task object that corresponds to the specified [taskId] inside the
  /// specified [subjectName].
  ///
  /// Throws exception `TaskNotFoundException` if specified `taskId` is not found
  /// and `SubjectNotFoundException` if specified `subjectName` is not found.
  static Future<Task> getTask({required int taskId}) async {
    List<Task> taskList = await getAllTasks();
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].id == taskId) {
        return taskList[i];
      }
    }

    // If the loop completes without finding the specified id, then throw
    // exception
    throw TaskNotFoundException();
  }
}
