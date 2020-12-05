import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/model/event.dart';
import 'package:nityaassociation/ui/event/chew_video_player.dart';
import 'package:nityaassociation/ui/event/event_details.dart';

class EventItem extends StatelessWidget {
  final EventModel event;

  EventItem(this.event);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
          context, CupertinoPageRoute(builder: (_) => EventDetails(event))),
      title: Text(
        event.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Hero(
        tag: event.id,
        child: Container(
          width: 96,
          child: event.urlType == 1
              ? Container(
                  color: Colors.grey.shade200,
                  child: ChewVideoPlayer(event.url, false))
              : Image.network(
                  event.url,
                  width: 96,
                  fit: BoxFit.fill,
                ),
        ),
      ),
      subtitle: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Event",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                event.timestamp,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
