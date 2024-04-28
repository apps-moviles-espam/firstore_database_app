import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_database_app/models/task.dart';

class DatabaseService {
  final firestore = FirebaseFirestore.instance;
  late final CollectionReference tasksRef;

  DatabaseService() {
    tasksRef = firestore.collection("tasks").withConverter<Task>(
        fromFirestore: (snapshots, _) => Task.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (task, _) => task.toJson());
  }

  Stream<QuerySnapshot> getTasks() {
    return tasksRef.snapshots();
  }

  void addTodo(Task task) async {
    tasksRef.add(task);
  }

  void updateTodo(String taskId, Task task) {
    tasksRef.doc(taskId).update(task.toJson());
  }

  void deleteTodo(String taskId) {
    tasksRef.doc(taskId).delete();
  }
}
