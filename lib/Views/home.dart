import 'package:drift/drift.dart' as drift;
import 'package:flutter_todo_app/Views/todo_item_entry_dialog.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/Domain/Database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/Views/todo_list_item.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _showAddTaskScreen(BuildContext context) {
    final TextEditingController titleTextFieldController =
        TextEditingController();
    final TextEditingController contentTextFieldController =
        TextEditingController();
    String taskTitle = "";
    String taskContent = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TodoItemEntryDialog(
          onConfirm: (String title, String content) async {
            try {
              await database.into(database.todoItems).insert(
                    TodoItemsCompanion.insert(
                      title: taskTitle,
                      content: taskContent,
                    ),
                  );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task added successfully')),
                );
                Navigator.pop(context);
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add task: $e')),
                );
              }
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<TodoItem>>(
        stream: database.todoItems.all().watch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No todos yet'));
          }

          final todoItems = snapshot.data!;
          return ListView.builder(
            itemCount: todoItems.length,
            itemBuilder: (context, index) {
              return TodoListItem(
                title: todoItems[index].title,
                content: todoItems[index].content,
                onSelected: (value) {
                  logger.d(value);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskScreen(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
