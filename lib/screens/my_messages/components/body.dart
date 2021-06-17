import 'package:flutter/material.dart';
import '../../../models/Chat.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, i) => OutlinedButton(
        onPressed: () => {},
        child: new Column(
          children: [
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              leading: new CircleAvatar(),
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    dummyData[i].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dummyData[i].time,
                    style: TextStyle(color: Colors.grey, fontSize: 13.0),
                  )
                ],
              ),
              subtitle: Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  dummyData[i].message,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
