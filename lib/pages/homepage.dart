import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/database/firebase_api.dart';
import 'package:my_todo/model.dart';
import 'package:my_todo/provider/todos_provider.dart';
import 'package:my_todo/widget/add_todo_dialog.dart';
import 'package:my_todo/widget/completed_list.dart';
import 'package:my_todo/widget/todo_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tabs = [
      const TodoListWidget(),
      const CompletedList(),
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            user!.displayName!,
            style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          centerTitle: true,
          actions: [
            CircleAvatar(
              maxRadius: 35,
              backgroundImage: NetworkImage(user!.photoURL.toString()),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          selectedItemColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: (index) => setState(() {
            selectedIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.fact_check_outlined,
              ),
              label: 'Todos',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.done,
                size: 28,
              ),
              label: 'Completed',
            ),
          ],
        ),
        body: StreamBuilder<List<Todo>>(
          stream: FirebaseApi.readTodos(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Text('Something Went Wrong Try later');
                } else {
                  final todos = snapshot.data;

                  final provider = Provider.of<TodosProvider>(context);
                  provider.setTodos(todos!);

                  return tabs[selectedIndex];
                }
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.blue,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddTodoDialogWidget(),
            barrierDismissible: false,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
