import 'package:chat_ui/screens/homescreen.dart';
import 'package:chat_ui/screens/loginscreen.dart';
import 'package:chat_ui/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/usermodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // User? currentUser=FirebaseAuth.instance.currentUser;
  // if (currentUser==null) {
  runApp(const MyApp());
  // }
  // else{
  //   runApp(MyAppLoggedIn(userModel: userModel, firebaseUser: currentUser));
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Chat UI",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFFFEF9EB)),
      ),
      home: LoginScreen(key: key),
      routes: {
        SignupScreen.routeName: (context) => SignupScreen(),
      },
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Chat UI",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFFFEF9EB)),
      ),
      home: HomeScreen(firebaseUser: firebaseUser, userModel: userModel),
      routes: {
        SignupScreen.routeName: (context) => SignupScreen(),
      },
    );
  }
}
