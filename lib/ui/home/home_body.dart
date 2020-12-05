import 'package:flutter/material.dart';
import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/ui/common/post_item.dart';
import 'package:nityaassociation/ui/home/bloc/post_bloc.dart';
import 'package:nityaassociation/utils/app_utils.dart';

class HomeBody extends StatefulWidget {
  final int index;
  final List<Post> posts;

  HomeBody(this.index, this.posts);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final List<String> categories = <String>[
    'All',
    'Compliance Calender',
    'Insight',
    'Legal Precedents Series',
    'Outlook'
  ];



  String value = 'All';
  List<Post> modifiedPost = List();

  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      case 0:
        modifiedPost = widget.posts;
        break;
      case 1:
        //update
        int i = categories.indexOf(value);

        if (i == 0) {
          modifiedPost =
              widget.posts.where((element) => element.postType == 0).toList();
        } else {
          modifiedPost = widget.posts
              .where((element) =>
                  element.postType == 0 && element.category == (i - 1))
              .toList();
        }
        break;
      case 2:
        //article

        modifiedPost =
            widget.posts.where((element) => element.postType == 1).toList();
        break;
      case 3:
        //video
        modifiedPost =
            widget.posts.where((element) => element.postType == 2).toList();
    }
    int length = modifiedPost.length;

    return Scaffold(
      bottomNavigationBar: widget.index == 1
          ? Container(
              height: 56,
              child: ListTile(
                title: Text(
                  "Filter By",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: DropdownButton<String>(
                  value: value,
                  selectedItemBuilder: (_) {
                    return categories
                        .map((e) => Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                e,
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ))
                        .toList();
                  },
                  items: categories.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (va) {
                    setState(() {
                      value = va;
                    });
                  },
                ),
              ),
            )
          : Container(
              height: 0,
            ),
      body: RefreshIndicator(
        onRefresh: fetchPosts,
        child: modifiedPost.isEmpty
            ? Container(
                child: Center(child: Text("No Posts")),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (_, i) {
                  return PostItem(modifiedPost[i]);
                },
                separatorBuilder: (_, __) => Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                itemCount: length),
      ),
    );
  }

  Future<void> fetchPosts() async {
    await postBloc.fetchPosts(AppUtils.currentUser.accessToken);
    return;
  }
}
