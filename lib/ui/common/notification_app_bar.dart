import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/ui/notifications/notifications.dart';

class NotificationAppBar extends StatelessWidget {
  final String title;

  NotificationAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      brightness: Brightness.dark,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (_) => NotificationPage()));
            })
      ],
    );
  }
}
