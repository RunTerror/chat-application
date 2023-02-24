import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/chatroommodel.dart';
import '../models/usermodel.dart';

class ChatRoomPage extends StatelessWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;
  const ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.chatroom,
    required this.firebaseUser,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: CircleAvatar(),
          ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Row(
              children: const [
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter message",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
