import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_database_app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "TASKS",
        ),
      ),
      body: Column(children: [taskListView()]),
      floatingActionButton: FloatingActionButton(
        onPressed: textInputDialog,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  taskListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: databaseService.getTasks(),
        builder: (context, snapshot) {
          List taks = snapshot.data?.docs ?? [];
          if (taks.isEmpty) {
            return const Center(
              child: Text("Add a task!"),
            );
          }
          return ListView.builder(
            itemCount: taks.length,
            itemBuilder: (context, index) {
              Task task = taks[index].data();
              String taskId = taks[index].id;
              return ListTile(
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                title: Text(task.todo),
                subtitle: Text(
                  DateFormat("dd-MM-yyyy h:mm a").format(
                    task.updatedOn.toDate(),
                  ),
                ),
                trailing: Checkbox(
                  value: task.isDone,
                  onChanged: (value) {
                    Task updatedTodo = task.copyWith(
                        isDone: !task.isDone, updatedOn: Timestamp.now());
                    databaseService.updateTodo(taskId, updatedTodo);
                  },
                ),
                onLongPress: () {
                  databaseService.deleteTodo(taskId);
                },
              );
            },
          );
        },
      ),
    );
  }

  textInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a task'),
          content: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(hintText: "Insert a task"),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Ok'),
              onPressed: () {
                Task todo = Task(
                    todo: textEditingController.text,
                    isDone: false,
                    createdOn: Timestamp.now(),
                    updatedOn: Timestamp.now());
                databaseService.addTodo(todo);
                Navigator.pop(context);
                textEditingController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
