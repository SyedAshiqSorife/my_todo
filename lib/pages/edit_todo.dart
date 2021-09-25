import 'package:flutter/material.dart';
import 'package:my_todo/model.dart';
import 'package:my_todo/provider/todos_provider.dart';
import 'package:my_todo/widget/todo_form.dart';
import 'package:provider/provider.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;
  const EditTodoPage({Key? key, required this.todo}) : super(key: key);

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();

  String? title;
  String? description;

  @override
  void initState() {
    super.initState();
    title = widget.todo.title;
    description = widget.todo.description;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Edit Todo'),
          ),
          actions: [
            IconButton(
              onPressed: () {
                final provider =
                    Provider.of<TodosProvider>(context, listen: false);
                provider.removeTodo(widget.todo);

                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: TodoForm(
              title: title!,
              description: description!,
              onChangedTitle: (title) => setState(() => this.title = title),
              onChangedDescription: (description) =>
                  setState(() => this.description = description),
              onSavedTodo: saveTodo,
            ),
          ),
        ),
      ),
    );
  }

  void saveTodo() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      final provider = Provider.of<TodosProvider>(context, listen: false);

      provider.updateTodo(widget.todo, title!, description!);

      Navigator.of(context).pop();
    }
  }
}
