import 'package:chat_ui/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelbyId(String uid) async {
    UserModel? usermodel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (docsnap.data() != null) {
      usermodel = UserModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return usermodel;
  }
}
