import 'package:flutter/material.dart';
import 'package:nityaassociation/model/navigation_util.dart';
import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/ui/common/error_page.dart';
import 'package:nityaassociation/ui/common/loading_page.dart';
import 'package:nityaassociation/ui/home/bloc/post_bloc.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:provider/provider.dart';

import 'home_body.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _tabs = ['All', 'Updates', 'Articles', 'Videos'];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  PageController _controller = PageController();
  PostBloc _bloc = PostBloc();

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationModel>(context);
    _currentPage = navigation.homeIndex;
    return Scaffold(
      body: StreamBuilder<PostResponse>(
        stream: _bloc.posts,
        builder: (context, AsyncSnapshot<PostResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return ErrorPage(
                errorMsg: snapshot.data.error,
                retry: fetchPosts,
              );
            }
            return buildPosts(navigation, snapshot.data.posts);
          } else if (snapshot.hasError) {
            return ErrorPage(
              errorMsg: snapshot.error,
              retry: fetchPosts,
            );
          } else {
            return LoadingPage("Fetching Posts");
          }
        },
      ),
      appBar: buildAppBar(),
    );
  }

  PageView buildPosts(NavigationModel navigation, List<Post> posts) {
    return PageView.builder(
        itemCount: _tabs.length,
        onPageChanged: (index) {
          navigation.setHomeIndex(index);
        },
        controller: _controller,
        itemBuilder: (context, index) {
          return HomeBody(navigation.homeIndex, posts);
        });
  }

  Future<void> fetchPosts() async {
    await _bloc.fetchPosts(AppUtils.currentUser.accessToken);
    return;
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
      child: Container(
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _tabs.map((e) {
            int indexOfCurrentItem = _tabs.indexOf(e);
            return InkWell(
              onTap: () {
                _controller.animateToPage(indexOfCurrentItem,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: _currentPage == indexOfCurrentItem
                                ? Colors.grey.shade600
                                : Colors.transparent,
                            width: 2))),
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: Text(e),
              ),
            );
          }).toList(),
        ),
      ),
      preferredSize: Size.fromHeight(36),
    );
  }
}
