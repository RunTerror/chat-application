// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:chat_ui/models/usermodel.dart';
import 'package:chat_ui/screens/homescreen.dart';
import 'package:chat_ui/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontrooler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void login(String email, String password) async {
      UserCredential? credential;
      try {
        credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        print(e.toString());
      }

      if (credential != null) {
        final uid = credential.user!.uid;
        DocumentSnapshot userData =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        UserModel usermodel =
            UserModel.fromMap(userData.data() as Map<String, dynamic>);
        print("Log in Screen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen(
                firebaseUser: credential!.user!,
                userModel: usermodel,
              );
            },
          ),
        );
      }
    }

    void checkStatus() {
      final email = emailcontroller.text.trim();
      final password = passwordcontrooler.text.trim();

      if (email == "" || password == "") {
        log("Fill the information" as num);
      } else {
        login(email, password);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const Text(
                    "Chat App",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: "Email Address"),
                    controller: emailcontroller,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    controller: passwordcontrooler,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      checkStatus();
                    },
                    color: Colors.blue,
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          CupertinoButton(
            onPressed: () {
              Navigator.pushNamed(context, SignupScreen.routeName);
            },
            child: const Text("Sign Up"),
          )
        ],
      ),
    );
  }
}
