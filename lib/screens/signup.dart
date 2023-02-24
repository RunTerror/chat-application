import 'package:chat_ui/models/usermodel.dart';
import 'package:chat_ui/screens/completeprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  static const routeName = '/signupscreen';
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontrooler = TextEditingController();
  TextEditingController confirmcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void signup(String email, String password) async {
      UserCredential? credential;
      try {
        credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        print(e.code.toString());
      }
      if (credential != null) {
        String uid = credential.user!.uid;
        UserModel newuser = UserModel(
          email: email,
          fullName: "",
          profilepic: "",
          uid: uid,
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set(newuser.toMap())
            .then(
          (value) {
            print("New User Created!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CompleteProfile(
                    firebaseUser: credential!.user!,
                    userModel: newuser,
                  );
                },
              ),
            );
          },
        );
      }
    }

    void checkValues() {
      String email = emailcontroller.text.trim();
      String password = passwordcontrooler.text.trim();
      String cpassword = confirmcontroller.text.trim();

      if (email == "" || password == "" || cpassword == "") {
        if (kDebugMode) {
          print("please fill the fields");
        }
      } else if (password != cpassword) {
        if (kDebugMode) {
          print("Password do not match");
        }
      } else {
        signup(email, password);
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
                        fontWeight: FontWeight.bold),
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
                    decoration:
                        const InputDecoration(labelText: "Enter Password"),
                    controller: passwordcontrooler,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: "Confirm Password"),
                    controller: confirmcontroller,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      checkValues();
                    },
                    color: Colors.blue,
                    child: const Text("Sign Up"),
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
          const Text("Already have an account?"),
          CupertinoButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Log In",
            ),
          )
        ],
      ),
    );
  }
}
