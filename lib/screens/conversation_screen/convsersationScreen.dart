import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/chats_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final String uid = FirebaseAuth.instance.currentUser.uid;
  TextEditingController messageController = new TextEditingController();

  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapShot) {
          return ListView.builder(
              itemCount: snapShot.data.documents.length,
              itemBuilder: (context, index) {
                return MessageTile(
                    // wither doc or documents
                    snapShot.data.docs[index]["message"]);
              });
        });
  }

  sendMessage() async {
    final userName = await DatabaseMethods().userName(uid);
    if (messageController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageController.text,
        "sendBy": userName.join(""),
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    DatabaseMethods().getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            // fillColor: Colors.lightBlue.shade600,
                            hintText: "Message.....",
                            hintStyle: TextStyle(color: Colors.blue.shade600),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: FloatingActionButton(
                          onPressed: () {
                            print(AuthentificationService()
                                .currentUser
                                .displayName);
                            sendMessage();
                          },
                          child: Icon(
                            Icons.send_rounded,
                            size: 40,
                          ),
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        message,
      ),
    );
  }
}
