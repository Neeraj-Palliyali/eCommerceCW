import 'package:flutter/material.dart';
import 'components/body.dart';

class SingleChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
      ),
      body: Body(),
    );
  }
}
