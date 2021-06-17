import 'package:flutter/material.dart';

class ChatModel {
  final String name;
  final String message;
  final String time;

  ChatModel({
    @required this.name,
    @required this.message,
    @required this.time,
  });
}

List<ChatModel> dummyData = [
  ChatModel(
    name: "NeerajP",
    message: "Hey",
    time: "15:30",
  ),
  ChatModel(
    name: "Sid",
    message: "Hey",
    time: "15:50",
  ),
];
