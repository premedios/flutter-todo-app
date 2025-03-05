import 'package:flutter/material.dart';

class TodoEntryForm extends StatefulWidget {
  const TodoEntryForm({super.key});

  @override
  _TodoEntryFormState createState() => _TodoEntryFormState();
}

class _TodoEntryFormState extends State<TodoEntryForm> {
  final _formKey = GlobalKey<FormState>();
  String _todoTitle = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Todo Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            onSaved: (value) {
              _todoTitle = value!;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Handle the submission of the todo entry
              }
            },
            child: Text('Add Todo'),
          ),
        ],
      ),
    );
  }
}
