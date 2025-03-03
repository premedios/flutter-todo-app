import 'package:flutter/material.dart';

class TodoItemEntryDialog extends StatefulWidget {
  const TodoItemEntryDialog({super.key});

  @override
  _TodoItemEntryDialogState createState() => _TodoItemEntryDialogState();
}

class _TodoItemEntryDialogState extends State<TodoItemEntryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Modal Screen Title'),
                // Your modal content here
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
