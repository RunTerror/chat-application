import 'package:chat_ui/main.dart';
import 'package:chat_ui/models/chatroommodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/usermodel.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textsearchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel chatroom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docdata = snapshot.docs[0].data();
      ChatRoomModel existingModel =
          ChatRoomModel.fromMap(docdata as Map<String, dynamic>);
          chatroom=existingModel;
    } else {
      ChatRoomModel newChatroom =
          ChatRoomModel(chatroomid: uuid.v1(), lastMessage: "", participants: {
        widget.userModel.uid.toString(): true,
        targetUser.uid.toString(): true,
      });

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(
            newChatroom.toMap(),
          );
          chatroom =newChatroom;
    }

    return chatroom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Email address",
              ),
              controller: textsearchController,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CupertinoButton(
            onPressed: () {
              setState(() {});
            },
            color: Theme.of(context).colorScheme.primary,
            child: const Text("Search"),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData == true) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                  if (dataSnapshot.docs.isNotEmpty) {
                    Map<String, dynamic> userMap =
                        dataSnapshot.docs[0].data() as Map<String, dynamic>;

                    UserModel searchedUser = UserModel.fromMap(userMap);
                    return ListTile(
                      onTap: () async {
                        ChatRoomModel? chatRoomModel =
                            await getChatroomModel(searchedUser);
                        // Navigator.of(context).pop();
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return ChatRoomPage(
                        //         firebaseUser: widget.firebaseUser,
                        //         targetUser: searchedUser,
                        //         userModel: widget.userModel,
                        //         chatroom: ,
                        //       );
                        //     },
                        //   ),
                        // );
                      },
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchedUser.profilepic!)),
                      title: Text(searchedUser.fullName as String),
                      subtitle: Text(searchedUser.email as String),
                      trailing: const Icon(
                        Icons.arrow_right,
                        size: 30,
                      ),
                    );
                  } else {
                    return const Text("No results found");
                  }
                } else if (snapshot.hasError) {
                  return const Text("An error occured");
                } else {
                  return const Text("No results found");
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("email", isEqualTo: textsearchController.text)
                .where("email", isNotEqualTo: widget.userModel.email)
                .snapshots(),
          )
        ],
      ),
    );
  }
}
