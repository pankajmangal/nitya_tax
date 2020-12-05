import 'package:flutter/material.dart';
import 'package:nityaassociation/ui/common/notification_app_bar.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: NotificationAppBar('Terms & Conditions'),
          preferredSize: Size.fromHeight(56)),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          style: TextStyle(fontSize: 16, color: Colors.black45),
        ),
      ),
    );
  }
}
