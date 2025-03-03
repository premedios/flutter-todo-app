import 'package:flutter/material.dart';

class TodoListItem extends StatefulWidget {
  final String title;
  final String content;

  const TodoListItem({super.key, required this.title, required this.content});

  @override
  _TodoListItemState createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 1,
        shadowColor: Colors.black38,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            Text(widget.content),
          ],
        ),
      ),
    );
  }
}
