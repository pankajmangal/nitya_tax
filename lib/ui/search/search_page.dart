import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/model/event.dart';
import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/model/search.dart';
import 'package:nityaassociation/ui/event/event_details.dart';
import 'package:nityaassociation/ui/feedback/feedback_page.dart';
import 'package:nityaassociation/ui/post/post_detail_page.dart';
import 'package:nityaassociation/ui/search/bloc/search_bloc.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchBloc _bloc = SearchBloc();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.searchStream.listen((event) {
      setState(() {
        posts = event ?? [];
      });
    });
    _bloc.loadingStream.listen((event) {
      setState(() {
        isSearching = event;
      });
    });

    _bloc.errorStream.listen((event) {
      setState(() {
        isSearching = false;
      });
      AppUtils.showError(event, key);
    });
  }

  bool isSearching = false;

  List<Search> posts = List();

  GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isSearching
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Result(s)",
                    style: TextStyle(fontSize: 16),
                  ),
                  posts.length == 0
                      ? Text("No Results")
                      : ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: posts.length,
                              itemBuilder: (_, index) {
                                return ListTile(
                                  onTap: () {
                                    if (posts[index].postType == 3) {
                                      //its event
                                      Search e = posts[index];
                                      EventModel event = EventModel(
                                          id: e.eventsId,
                                          title: e.title,
                                          bookmarkedBy: e.bookmarkedBy,
                                          description: e.description,
                                          postType: e.postType,
                                          registrationLink: e.registrationLink,
                                          timestamp: e.timestamp,
                                          urlType: e.urlType,
                                          url: e.url);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EventDetails(event)));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => PostDetails(
                                                  Post.fromJson(
                                                      posts[index].toJson()))));
                                    }
                                  },
                                  contentPadding: EdgeInsets.all(0),
                                  trailing: Text(
                                    AppUtils.getPostTypeByCode(
                                      posts[index].postType,
                                    ),
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                  title: Text(
                                    posts[index].title,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    posts[index].description,
                                    maxLines: 1,
                                  ),
                                  dense: true,
                                );
                              }),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.only(left: 16, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: TextField(
                controller: _controller,
                onChanged: (k) {
                  if (k.length > 2) {
                    posts.clear();
                    _bloc.search(k, AppUtils.currentUser.accessToken);
                  }
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    suffixIcon: Icon(Icons.search)),
              ),
            ),
            color: kPrimaryColor,
          ),
          preferredSize: Size.fromHeight(56)),
    );
  }
}
