import 'package:e_commerce_app_flutter/screens/conversation_screen/ConvsersationScreen.dart';
import 'package:e_commerce_app_flutter/screens/single_chat_screen/single_chat_screen.dart';
import 'package:e_commerce_app_flutter/services/database/chats_database.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

import '../../../utils.dart';

class AddToCartFAB extends StatelessWidget {
  const AddToCartFAB({
    Key key,
    @required this.productId,
  }) : super(key: key);

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 155,
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.00),
                    bottomLeft: Radius.circular(20.00))),
            onPressed: () async {
              bool allowed = AuthentificationService().currentUserVerified;
              if (!allowed) {
                final reverify = await showConfirmationDialog(context,
                    "You haven't verified your email address. This action is only allowed for verified users.",
                    positiveResponse: "Resend verification email",
                    negativeResponse: "Go back");
                if (reverify) {
                  final future = AuthentificationService()
                      .sendVerificationEmailToCurrentUser();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return FutureProgressDialog(
                        future,
                        message: Text("Resending verification email"),
                      );
                    },
                  );
                }
                return;
              }
              bool addedSuccessfully = false;
              String snackbarMessage;
              try {
                addedSuccessfully =
                    await UserDatabaseHelper().addProductToCart(productId);
                if (addedSuccessfully == true) {
                  snackbarMessage = "Product added successfully";
                } else {
                  throw "Coulnd't add product due to unknown reason";
                }
              } on FirebaseException catch (e) {
                Logger().w("Firebase Exception: $e");
                snackbarMessage = "Something went wrong";
              } catch (e) {
                Logger().w("Unknown Exception: $e");
                snackbarMessage = "Something went wrong";
              } finally {
                Logger().i(snackbarMessage);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(snackbarMessage),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: Text(
              "Add to cart",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 2,
        ),
        SizedBox(
          width: 155,
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.00),
                    bottomRight: Radius.circular(20.00))),
            onPressed: () async {
              bool allowed = AuthentificationService().currentUserVerified;
              if (!allowed) {
                final reverify = await showConfirmationDialog(context,
                    "You haven't verified your email address. This action is only allowed for verified users.",
                    positiveResponse: "Resend verification email",
                    negativeResponse: "Go back");
                if (reverify) {
                  final future = AuthentificationService()
                      .sendVerificationEmailToCurrentUser();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return FutureProgressDialog(
                        future,
                        message: Text("Resending verification email"),
                      );
                    },
                  );
                }
                return;
              }
              final username = await UserDatabaseHelper().userName;
              final response =
                  await createChatRoomAndStartConversation(username, productId);
              if (!response) {
                SnackBar snackBar = SnackBar(
                  content: Text(
                    "Can't talk to yourself",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(milliseconds: 600),
                );
                ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
              } else {
                // got to
                // complete this messaging :)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationScreen()));
              }
            },
            label: Text(
              "Message",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            icon: Icon(Icons.message_outlined),
          ),
        ),
      ],
    );
  }
}

Future<bool> createChatRoomAndStartConversation(
    String username, productId) async {
  final uid2s = await ProductDatabaseHelper().findOwner(productId);
  final uid2 = uid2s.join("");
  final userName1 = await DatabaseMethods().userName(username);
  final userName2 = await DatabaseMethods().userName(uid2);

  List<String> users = [userName1.join(""), userName2.join("")];

  if (username == uid2) {
    return false;
  } else {
    String chatRoomId = getChatRoomId(username, uid2);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };

    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    return true;
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
