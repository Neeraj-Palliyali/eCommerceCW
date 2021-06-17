import 'package:e_commerce_app_flutter/screens/my_messages/components/chat_room_time.dart';
import 'package:e_commerce_app_flutter/services/database/chats_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/Chat.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final userName = FirebaseAuth.instance.currentUser.displayName;

  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapShot) {
          return ListView.builder(
              itemCount: snapShot.data.documents.length,
              itemBuilder: (context, index) {
                return snapShot.hasData
                    ? ChatRoomTile(
                        chatRoomId: snapShot.data.documents[index]
                            ["chatroomId"],
                        userName: snapShot.data.documents[index]["chatroomId"]
                            .toString()
                            .replaceAll(userName + "_", ""),
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return chatRoomList();
  }
}

// commented model
// new ListView.builder(
//       itemCount: dummyData.length,
//       itemBuilder: (context, i) => OutlinedButton(
//         onPressed: () => {},
//         child: new Column(
//           children: [
//             new Divider(
//               height: 10.0,
//             ),
//             new ListTile(
//               leading: new CircleAvatar(),
//               title: new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     dummyData[i].name,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     dummyData[i].time,
//                     style: TextStyle(color: Colors.grey, fontSize: 13.0),
//                   )
//                 ],
//               ),
//               subtitle: Container(
//                 padding: EdgeInsets.only(top: 5),
//                 child: Text(
//                   dummyData[i].message,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
