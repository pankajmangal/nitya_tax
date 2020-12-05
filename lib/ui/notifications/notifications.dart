import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nityaassociation/model/notification_model.dart';
import 'package:nityaassociation/ui/notifications/bloc/notification_bloc.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationBloc _bloc = NotificationBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: _bloc.notifications,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data[0].toJson().toString());
              return Container(
                child: snapshot.data?.length == 0
                    ? Center(
                        child: Text("No Notifications"),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          NotificationModel m = snapshot.data[index];
                          DateTime tempDate =
                              new DateFormat("yyyy-MM-dd hh:mm:ss")
                                  .parse(m.date);
                          final timeAgo = timeago.format(tempDate);

                          return Container(
                            color: m.markRead == '1'
                                ? Colors.transparent
                                : kPrimaryColor.withOpacity(0.2),
                            child: ListTile(
                              dense: true,
                              leading: Container(
                                  width: 56,
                                  color: Colors.grey,
                                  child: Image.network(m.image)),
                              title: Text(m.title),
                              subtitle: Text(
                                timeAgo,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        }),
              );
            } else if (snapshot.hasError) {
              print("csd");
              return Container(
                child: Center(
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Fetching Notifications...",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
