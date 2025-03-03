import 'package:drift/drift.dart' as drift;
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
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Compact header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text('Add New Task',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(height: 1),
                    // Scrollable form area
                    Flexible(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        shrinkWrap: true,
                        children: [
                          TextField(
                            controller: titleTextFieldController,
                            decoration: const InputDecoration(
                              hintText: 'Enter task title',
                              isDense: true, // More compact input
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (value) {
                              taskTitle = value;
                            },
                            autofocus: true,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: contentTextFieldController,
                            decoration: const InputDecoration(
                              hintText: 'Enter task content',
                              isDense: true, // More compact input
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (value) {
                              taskContent = value;
                            },
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if ((taskTitle.isNotEmpty &&
                                      taskTitle.length >= 6) &&
                                  taskContent.isNotEmpty) {
                                try {
                                  await database
                                      .into(database.todoItems)
                                      .insert(
                                        TodoItemsCompanion.insert(
                                          title: taskTitle,
                                          content: taskContent,
                                        ),
                                      );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Task added successfully')),
                                    );
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Failed to add task: $e')),
                                    );
                                  }
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                  content: todoItems[index].content);
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
