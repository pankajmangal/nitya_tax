import 'package:flutter/material.dart';
import 'package:nityaassociation/model/bookmark_model.dart';
import 'package:nityaassociation/ui/event/chew_video_player.dart';
import 'package:nityaassociation/ui/post/post_detail_page.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';

class BookMarkItem extends StatelessWidget {
  final BookmarkModel _bookmarkModel;

  BookMarkItem(this._bookmarkModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PostDetails(_bookmarkModel.post)));
        },
        title: Text(
          _bookmarkModel.post.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          AppUtils.getPostTypeByCode(_bookmarkModel.post.postType),
          style: TextStyle(color: kPrimaryColor),
        ),
        trailing: _bookmarkModel.post.postType == 2
            ? Container(
                width: 76,
                color: Colors.grey.shade200,
                child: FittedBox(
                  child: ChewVideoPlayer(_bookmarkModel.post.url, false),
                ),
              )
            : Container(
                width: 76,
                child: Image.network(_bookmarkModel.post.url),
              ),
      ),
    );
  }
}
