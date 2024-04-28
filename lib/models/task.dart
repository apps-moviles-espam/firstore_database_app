import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String todo;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;

  Task({
    required this.todo,
    required this.isDone,
    required this.createdOn,
    required this.updatedOn,
  });

  Task.fromJson(Map<String, Object?> json)
      : this(
          todo: json['todo']! as String,
          isDone: json['isDone']! as bool,
          createdOn: json['createdOn']! as Timestamp,
          updatedOn: json['updatedOn']! as Timestamp,
        );

  Task copyWith({
    String? task,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return Task(
        todo: task ?? this.todo,
        isDone: isDone ?? this.isDone,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object?> toJson() {
    return {
      'todo': todo,
      'isDone': isDone,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
