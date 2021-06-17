import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  static const String ROOMNAME = "ChatRoom";
  static const String USERCOLLEC = "users";
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection(ROOMNAME)
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  uidToUserName(String userName, String uid) {
    FirebaseFirestore.instance
        .collection(USERCOLLEC)
        .doc(uid)
        .set({"username": userName});
  }

  Future<List<String>> userName(uid) async {
    final handle =
        await FirebaseFirestore.instance.collection(USERCOLLEC).doc(uid).get();
    final userNames = await handle.data()["username"];
    Set userName = Set<String>();
    userName.add(userNames);
    return userName.toList();
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection(ROOMNAME)
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  Future getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection(ROOMNAME)
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }
}
