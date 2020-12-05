import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/model/event.dart';
import 'package:nityaassociation/ui/common/notification_app_bar.dart';
import 'package:nityaassociation/ui/feedback/feedback_page.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chew_video_player.dart';

class EventDetails extends StatefulWidget {
  final EventModel event;

  EventDetails(this.event);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDynamicLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16),
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: kPrimaryColor,
          onPressed: () {
            try {
              launch(widget.event.registrationLink);
            } catch (e) {
              Exception("Couldn't launch the url");
            }
          },
          child: Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: widget.event.id,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: widget.event.urlType == 1
                        ? ChewVideoPlayer(widget.event.url, true)
                        : Image.network(
                            widget.event.url,
                            height: 196,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8, right: 16, left: 16),
                  child: Text(
                    widget.event.timestamp,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          widget.event.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.share,
                        ),
                        onPressed: () {
                          if (url != null)
                            Share.share(
                                "Checkout this event ${url.shortUrl} on NTA App",
                                subject: 'Event on NTA');
                        })
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.event.description,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      appBar: PreferredSize(
        child: NotificationAppBar("Events"),
        preferredSize: Size.fromHeight(56),
      ),
    );
  }

  ShortDynamicLink url;

  createDynamicLink() async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: "https://nityaassociation.page.link",
      link: Uri.parse(
          "https://nityaassociation.page.link/event?id=${widget.event.id}"),
      androidParameters:
          AndroidParameters(packageName: "com.entrepreter.nityaassociation"),
    );
    dynamicLinkParameters.buildShortLink().then((value) {
      setState(() {
        url = value;
      });
    });
  }
}
