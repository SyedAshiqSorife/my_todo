import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:my_todo/pages/homepage.dart';
import 'package:my_todo/provider/signin_provider.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => SignIn(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<SignIn>(context);

              if (provider.isSigningIn) {
                return Stack(
                  fit: StackFit.expand,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
                //is signin
              } else if (snapshot.hasData) {
                return const HomePage();
              } else {
                return Stack(
                  children: [
                    Column(
                      children: [
                        const Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            //width: 175,
                            child: const Text(
                              'My Todo',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          child: SignInButton(
                            Buttons.GoogleDark,
                            text: "Sign up with Google",
                            onPressed: () {
                              final provider =
                                  Provider.of<SignIn>(context, listen: false);
                              provider.login();
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Login to continue',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
