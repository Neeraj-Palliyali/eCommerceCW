import 'package:e_commerce_app_flutter/screens/conversation_screen/message_bubble.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/chats_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String sellerName;

  ConversationScreen(this.chatRoomId, this.sellerName);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final String uid = FirebaseAuth.instance.currentUser.uid;
  TextEditingController messageController = new TextEditingController();
  FocusNode _focusNode = FocusNode();

  Stream chatMessageStream;

  bool _inFocus = false;

  Widget chatMessageList() {
    return Container(
      height: _inFocus ? 300 : MediaQuery.of(context).size.height - 220,
      child: StreamBuilder(
          stream: chatMessageStream,
          builder: (context, snapShot) {
            if (snapShot.data == null)
              return Center(child: CircularProgressIndicator());

            return ListView.builder(
                reverse: true,
                itemCount: snapShot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                      snapShot.data.docs[index]["message"],
                      snapShot.data.docs[index]["sendBy"] ==
                          AuthentificationService().currentUser.displayName);
                });
          }),
    );
  }

  sendMessage() async {
    final userName = await DatabaseMethods().userName(uid);
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": userName.join(""),
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
    messageController.clear();
  }

  @override
  void initState() {
    DatabaseMethods().getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _inFocus = true;
        });
      } else {
        setState(() {
          _inFocus = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.sellerName.toUpperCase().replaceAll("_", " ")}",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            SizedBox(
              height: 20,
            ),
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
                          // fillColor: Colors.lightBlue.shade600
                          hintText: "Message.....",
                          hintStyle: TextStyle(color: Colors.blue.shade600),
                          border: InputBorder.none,
                        ),
                        focusNode: _focusNode,
                        onChanged: (value) {},
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 35,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _inFocus = false;
                          });
                          sendMessage();
                          _focusNode.unfocus();
                        }),
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
