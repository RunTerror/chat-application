import 'dart:developer';
import 'dart:io';
import 'package:chat_ui/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/usermodel.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile(
      {super.key, required this.firebaseUser, required this.userModel});
  final UserModel userModel;
  final User firebaseUser;
  static const routeName = '/complete-profile';
  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final fullNamecontroller = TextEditingController();
  File? _image;

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    File? img = File(image.path);
    setState(() {
      _image = img;
    });
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid as String)
        .putFile(_image!);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = fullNamecontroller.text.trim();

    widget.userModel.fullName = fullname;
    widget.userModel.profilepic = imageUrl;
    // print(fullname);

    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("Data uploaded");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomeScreen(
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
        );
      }));
    });
  }

  void checkValues() {
    String fullName = fullNamecontroller.text.trim();

    if (fullName == "" || _image == null) {
      print("Fill all the fields");
    } else {
      uploadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    void showPhotoOptions() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Upload Picture",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Select from gallery"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  title: const Text("Take a photo"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                showPhotoOptions();
              },
              child: CircleAvatar(
                backgroundImage: (_image != null) ? FileImage(_image!) : null,
                radius: 60,
                child: (_image != null)
                    ? null
                    : const Icon(
                        Icons.person,
                        size: 60,
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Full Name"),
              controller: fullNamecontroller,
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                checkValues();
              },
              color: Colors.blue,
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
