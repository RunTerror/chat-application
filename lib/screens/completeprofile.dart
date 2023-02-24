import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../models/usermodel.dart';
import 'homescreen.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({
    super.key,
    required this.firebaseUser,
    required this.userModel,
  });
  final UserModel userModel;
  final User firebaseUser;
  static const routeName = '/complete-profile';
  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final fullNamecontroller = TextEditingController();
  File? _image;

  void _pickImage(ImageSource source) async {
    try {
      XFile? pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;
      File? img = File(pickedImage.path);
      img = await _cropImage(
        img,
      );
      setState(() {
        _image = img;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedfile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      compressQuality: 100
    );
    if (croppedfile == null) return null;
    return File(croppedfile.path);
  }

  void checkValues() {
    String fullName = fullNamecontroller.text.trim();

    if (fullName == "" || _image == null) {
      print("Fill all the fields");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilePicture")
        .child(widget.userModel.uid.toString())
        .putFile(_image!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = fullNamecontroller.text.trim();

    widget.userModel.fullName = fullName;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then(
      (vlaue) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen(
                firebaseUser: widget.firebaseUser,
                userModel: widget.userModel,
              );
            },
          ),
        );
      },
    );
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
