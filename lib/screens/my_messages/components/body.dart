import 'package:e_commerce_app_flutter/screens/my_messages/components/chat_room_time.dart';
import 'package:e_commerce_app_flutter/services/database/chats_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final userName = FirebaseAuth.instance.currentUser.displayName;
  bool _isLoaded = false;

  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapShot) {
          if (snapShot.data == null)
            return Center(child: CircularProgressIndicator());

          return ListView.builder(
              itemCount: snapShot.data.documents.length,
              itemBuilder: (context, index) {
                return snapShot.hasData
                    ? ChatRoomTile(
                        chatRoomId: snapShot.data.documents[index]
                            ["chatroomId"],
                        userName: snapShot.data.documents[index]["chatroomId"]
                            .toString()
                            .replaceAll(userName, "")
                            .replaceAll("_", " "),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              });
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    await databaseMethods.getChatRooms(userName).then((val) {
      setState(() {
        chatRoomsStream = val;
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? chatRoomList()
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

// commented model
//
