import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  void createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  void uidToUserName(String userName, String uid) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set({"username": userName});
  }

  Future<List<String>> userName(uid) async {
    final handle =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final userNames = await handle.data()["username"];
    Set userName = Set<String>();
    userName.add(userNames);
    return userName.toList();
  }
}
