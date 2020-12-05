import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/model/event.dart';
import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/network/api_provider.dart';
import 'package:nityaassociation/ui/event/event_details.dart';
import 'package:nityaassociation/ui/post/post_detail_page.dart';
import 'package:nityaassociation/utils/app_utils.dart';

enum ContentType { POST, EVENT }

class DynamicPage extends StatefulWidget {
  final String id;
  final ContentType contentType;

  DynamicPage(this.id, this.contentType);

  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  var content;

  Future<Post> getPostById(String token, String postId) async {
    Map body = Map();
    body['access_token'] = token;
    body['post_id'] = postId;

    Response response =
        await _dioClient.post('/getpostbyid.php?page=1', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return Post.fromJson(response.data['post'][0]);
      } else {
        return Future.error(response.data['message']);
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  final Dio _dioClient = Dio(BaseOptions(
      baseUrl: 'https://projects.adsandurl.com/nitiya/api/',
      headers: {
        'Appversion': '1.0',
        'Ostype': Platform.isAndroid ? 'android' : 'ios'
      }));

  Future<EventModel> getEventById(String token, String eventId) async {
    Map body = Map();
    body['access_token'] = token;
    body['events_id'] = eventId;

    Response response =
        await _dioClient.post('/geteventbyid.php?page=1', data: body);
    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        print(response.data);
        var v = EventModel.fromJson(response.data['events'][0]);
        return v;
      } else {
        return Future.error(response.data['message']);
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  bool isLoading = true;
  bool isPost = false;
  bool isError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contentType == ContentType.POST) {
      isPost = true;
      getPostById(AppUtils.currentUser.accessToken, widget.id).then((value) {
        setState(() {
          isLoading = false;
          content = value;
        });
      }).catchError((e) {
        isLoading = false;
        isError = true;
      });
    } else if (widget.contentType == ContentType.EVENT) {
      isPost = false;
      print('isev');
      getEventById(AppUtils.currentUser.accessToken, widget.id).then((value) {
        setState(() {
          isLoading = false;
          content = value;
        });
      }).catchError((e) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: isLoading
              ? CircularProgressIndicator()
              : isError
                  ? Center(
                      child: Text("Something Went Wrong"),
                    )
                  : isPost ? PostDetails(content) : EventDetails(content)),
    );
  }
}
