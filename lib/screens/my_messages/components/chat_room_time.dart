import 'package:e_commerce_app_flutter/screens/conversation_screen/convsersationScreen.dart';
import 'package:flutter/material.dart';

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName, this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    print(chatRoomId);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(chatRoomId, userName)));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(50)),
              child: Text(
                properName(userName),
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height) / 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(userName),
            ),
          ],
        ),
      ),
    );
  }
}

String properName(String userName) {
  if ("${userName.substring(0, 1).toUpperCase()}" == " ") {
    return ("${userName.substring(1, 2).toUpperCase()}");
  }
  return "${userName.substring(0, 1).toUpperCase()}";
}
