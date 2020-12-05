import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/ui/event/chew_video_player.dart';
import 'package:nityaassociation/ui/post/post_detail_page.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';

class PostItem extends StatelessWidget {
  final Post post;

  PostItem(this.post);

  final List<String> categories = <String>[
    'Compliance Calender',
    'Insight',
    'Legal Precedents Series',
    'Outlook'
  ];

  @override
  Widget build(BuildContext context) {
    print(post.postType);
    return ListTile(
      onTap: () => Navigator.push(
          context, CupertinoPageRoute(builder: (_) => PostDetails(post))),
      title: Text(
        post.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Hero(
        tag: post.id.toString(),
        child: Container(
          color: Colors.grey.shade200,
          width: 96,
          child: post.postType == VIDEO
              ? FittedBox(child: ChewVideoPlayer(post.url, false))
              : Image.network(
                  post.url,
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
                post.postType == 0
                    ? categories[post.category]
                    : AppUtils.getPostTypeByCode(post.postType),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                post.timestamp,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
