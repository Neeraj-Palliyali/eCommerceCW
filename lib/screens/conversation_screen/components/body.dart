import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Widget ChatMessageList() {}
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
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
    );
  }
}
