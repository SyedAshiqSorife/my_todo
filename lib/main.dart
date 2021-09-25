import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/pages/homepage.dart';
import 'package:my_todo/pages/signin.dart';
import 'package:my_todo/provider/todos_provider.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => TodosProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const SignInPage(),
        ),
      );
}
