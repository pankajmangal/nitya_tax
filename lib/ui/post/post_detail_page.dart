import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/ui/bookmark/bloc/bookmark_bloc.dart';
import 'package:nityaassociation/ui/common/notification_app_bar.dart';
import 'package:nityaassociation/ui/event/chew_video_player.dart';
import 'package:nityaassociation/ui/feedback/feedback_page.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:nityaassociation/utils/image_helper.dart';
import 'package:share/share.dart';

class PostDetails extends StatefulWidget {
  final Post post;

  PostDetails(this.post);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  bool _isBooked = false;

  BookmarkBloc _bloc = BookmarkBloc();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    createDynamicLink();
    if (widget.post.bookmarkedBy
        .contains(AppUtils.currentUser.userId.toString())) {
      if (mounted)
        setState(() {
          _isBooked = true;
        });
    }
    _bloc.bookAddStream.listen((event) {
      if (event) {
        AppUtils.showError("Added to bookmarked", _globalKey);
      }
    });

    _bloc.bookErrorAddStream.listen((event) {
      AppUtils.showError(event, _globalKey);
    });

    _bloc.bookRemoveStream.listen((event) {
      if (event) {
        AppUtils.showError("Removed from bookmarked", _globalKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: widget.post.id.toString(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: widget.post.postType == VIDEO
                        ? ChewVideoPlayer(widget.post.url, true)
                        : Image.network(
                            widget.post.url,
                            height: 196,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Text(
                      widget.post.timestamp,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    )),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.post.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            _isBooked ? Icons.bookmark : Icons.bookmark_border,
                            color: _isBooked ? kPrimaryColor : kDarkColor,
                          ),
                          onPressed: () {
                            print("c");

                            if (_isBooked) {
                              _bloc.removeBookmark(
                                  AppUtils.currentUser.accessToken,
                                  widget.post.id.toString());
                            } else {
                              _bloc.addBookmark(
                                  AppUtils.currentUser.accessToken,
                                  widget.post.id.toString());
                            }

                            setState(() {
                              _isBooked = !_isBooked;
                            });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.share,
                          ),
                          onPressed: () {
                            if (url != null)
                              Share.share(
                                  "Checkout this ${url.shortUrl} on NTA App",
                                  subject: 'Post on NTA');
                          })
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.post.description,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        mini: true,
        elevation: 1,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FeedbackPage(
                        title: widget.post.title,
                        id: widget.post.id,
                      )));
        },
        child: SvgPicture.asset(
          QUERY_ICON,
          color: kPrimaryColor,
          height: 18,
        ),
      ),
      appBar: PreferredSize(
        child: NotificationAppBar(
            AppUtils.getPostTypeByCode(widget.post.postType)),
        preferredSize: Size.fromHeight(56),
      ),
    );
  }

  ShortDynamicLink url;

  createDynamicLink() async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: "https://nityaassociation.page.link",
      link: Uri.parse("https://nityaassociation.page.link/post?id=${widget.post.id}"),
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
