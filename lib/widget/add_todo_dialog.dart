import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/model.dart';
import 'package:my_todo/provider/todos_provider.dart';
import 'package:my_todo/widget/todo_form.dart';
import 'package:provider/provider.dart';

class AddTodoDialogWidget extends StatefulWidget {
  const AddTodoDialogWidget({Key? key}) : super(key: key);

  @override
  _AddTodoDialogWidgetState createState() => _AddTodoDialogWidgetState();
}

class _AddTodoDialogWidgetState extends State<AddTodoDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  String title = '';
  String description = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Todo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TodoForm(
              onChangedTitle: (title) => setState(() => this.title = title),
              onChangedDescription: (description) =>
                  setState(() => this.description = description),
              onSavedTodo: addTodo,
            ),
          ],
        ),
      ),
    );
  }

  void addTodo() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      final todo = Todo(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        createdTime: DateTime.now(),
        uid: user!.uid,
      );

      final provider = Provider.of<TodosProvider>(context, listen: false);
      provider.addTodo(todo);
      Navigator.of(context).pop();
    }
  }
}
