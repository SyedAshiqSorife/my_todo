import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_todo/model.dart';
import 'package:my_todo/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirebaseApi {
  static final user = FirebaseAuth.instance.currentUser;
  static Future<String> createTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc();

    todo.id = docTodo.id;
    await docTodo.set(todo.toJson());

    return docTodo.id;
  }

  static Stream<List<Todo>> readTodos() => FirebaseFirestore.instance
      .collection('todo')
      .orderBy(TodoField.createdTime, descending: true)
      .where('uid', isEqualTo: user!.uid)
      .snapshots()
      .transform(Utils.transformer(Todo.fromJson) as StreamTransformer<
          QuerySnapshot<Map<String, dynamic>>, List<Todo>>);

  static Future updateTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todo.id);

    await docTodo.update(todo.toJson());
  }

  static Future deleteTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todo.id);

    await docTodo.delete();
  }
}
