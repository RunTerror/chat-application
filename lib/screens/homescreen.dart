import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/usermodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {super.key, required this.firebaseUser, required this.userModel});

  final UserModel userModel;
  final User firebaseUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
      ),
      body: SafeArea(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.search),
      ),
    );
  }
}
