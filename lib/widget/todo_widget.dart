import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_todo/model.dart';
import 'package:my_todo/pages/edit_todo.dart';
import 'package:my_todo/provider/todos_provider.dart';
import 'package:my_todo/utils.dart';
import 'package:provider/provider.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;
  const TodoWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        key: Key(todo.id!),
        actions: [
          IconSlideAction(
            color: Colors.green,
            onTap: () => editTodo(context, todo),
            caption: 'Edit',
            icon: Icons.edit,
          )
        ],
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            caption: 'Delete',
            onTap: () => deleteTodo(context, todo),
            icon: Icons.delete,
          )
        ],
        child: buildTodo(context),
      ),
    );
  }

  Widget buildTodo(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => editTodo(context, todo),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            //checked box
            Checkbox(
              value: todo.isDone,
              activeColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
              onChanged: (_) {
                final provider =
                    Provider.of<TodosProvider>(context, listen: false);
                final isDone = provider.toggleTodoStatus(todo);

                Utils.showSnackBar(context,
                    isDone ? 'Task completed' : 'Task marked incomplete');
              },
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if (todo.description.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        todo.description,
                        style: const TextStyle(fontSize: 20, height: 1.5),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(todo);
    Utils.showSnackBar(context, 'Deleted the task');
  }

  void editTodo(BuildContext context, Todo todo) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditTodoPage(todo: todo),
        ),
      );
}
