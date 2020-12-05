import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nityaassociation/model/bookmark_model.dart';
import 'package:nityaassociation/model/bytes_model.dart';
import 'package:nityaassociation/model/event.dart';
import 'package:nityaassociation/model/feedback.dart';
import 'package:nityaassociation/model/login_model.dart';
import 'package:nityaassociation/model/notification_model.dart';
import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/model/query.dart';
import 'package:nityaassociation/model/search.dart';
import 'package:nityaassociation/model/sign_model.dart';
import 'package:nityaassociation/model/user.dart';

class ApiProvider {
  final Dio _dioClient = Dio(BaseOptions(
      baseUrl: 'https://projects.adsandurl.com/nitiya/api/',
      connectTimeout: 1000,
      receiveTimeout: 1000,
      headers: {
        'Appversion': '1.0',
        'Ostype': Platform.isAndroid ? 'android' : 'ios'
      }));

  Future<SignResponse> signUp(String name, String phone) async {
    final _map = Map();
    _map['name'] = name;
    _map['phone_no'] = phone;

    try {
      Response response = await _dioClient.post('/sign-up.php', data: _map);
      print(response.data);
      if (response.data != "") {
        if (response.data['success'] == true)
          return SignResponse.fromJson(response.data);
        else
          return SignResponse.fromError(
            response.data['message'],
            response.data['error_code'],
          );
      } else {
        return SignResponse.fromError("No data", 396);
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }
      return SignResponse.fromError("$e", 397);
    }

//    final _map = Map();
//    _map['name'] = name;
//    _map['phone_no'] = phone;

    Response response =
        await _dioClient.post('/sign-up.php', data: _map).catchError((error) {
      return Future.error(error.message);
    });

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      //we hit the api and status was ok
      if (response.data['success'] == true) {
        return response.data;
      } else {
        return Future.error(response.data);
      }
    } else {
      //could not hit the api may be because of internet
      return Future.error(response.statusMessage);
    }
  }

  Future<dynamic> verifySignUpOtp(String otp, String phone) async {
    final _map = {'otp': otp, 'phone_no': phone};

    Response response = await _dioClient
        .post('/signupverified.php', data: _map)
        .catchError((e) {
      return Future.error(e.message);
    });

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      //we hit the api and status was ok
      if (response.data['success'] == true) {
        return response.data;
      } else {
        return Future.error(response.data);
      }
    } else {
      //could not hit the api may be because of internet
      return Future.error(response.statusMessage);
    }
  }

  Future<LoginResponse> login(String phone) async {
    final _map = Map();
    _map['phone_no'] = phone;

    try {
      Response response = await _dioClient.post('/sign-in.php', data: _map);
      print(response.data);
      if (response.data != "") {
        if (response.data['success'] == true)
          return LoginResponse.fromJson(response.data);
        else
          return LoginResponse.fromError(response.data['message']);
      } else {
        return LoginResponse.fromError("No data");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }
      return LoginResponse.fromError("$e");
    }
//
//      return PostResponse.withError("$e");
//      final _map = Map();
//      _map['phone_no'] = phone;
//
//      Response response =
//      await _dioClient.post('/sign-in.php', data: _map).catchError((error) {
//        return Future.error(error.message);
//      });
//
//      if (response.statusCode == HttpStatus.ok) {
//        if (response.data == "") {
//          return Future.error("Servers have some issues");
//        }
//        //we hit the api and status was ok
//        if (response.data['success'] == true) {
//          return response.data;
//        } else {
//          return Future.error(response.data);
//        }
//      } else {
//        //could not hit the api may be because of internet
//        return Future.error(response.statusMessage);
//      }
  }

  Future<dynamic> verifyLoginOtp(String otp, String phone) async {
    final _map = {'otp': otp, 'phone_no': phone};

    Response response = await _dioClient
        .post('/signinverified.php', data: _map)
        .catchError((e) {
      return Future.error(e.message);
    });

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      //we hit the api and status was ok
      if (response.data['success'] == true) {
        return response.data;
      } else {
        return Future.error(response.data);
      }
    } else {
      //could not hit the api may be because of internet
      return Future.error(response.statusMessage);
    }
  }

  Future<String> resendOTP(String phone, int isPhoneVerified) async {
    final _map = {'is_phone_verified': isPhoneVerified, 'phone_no': phone};

    Response response =
        await _dioClient.post('/resendotp.php', data: _map).catchError((e) {
      return Future.error(e.message);
    });

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      return response.data['message'];
    } else {
      //could not hit the api may be because of internet
      return Future.error(response.statusMessage);
    }
  }

  Future<PostResponse> fetchPosts(String accessToken) async {
    final _map = {'access_token': accessToken};

    try {
      Response response = await _dioClient.post('/getpost.php', data: _map);
      if (response.data != "") {
        return PostResponse.fromJson(response.data);
      } else {
        return PostResponse.withError("No data");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }

      return PostResponse.withError("$e");
    }
  }

  Future<EventResponse> fetchEvents(String accessToken) async {
    final _map = {'access_token': accessToken};
    try {
      Response response = await _dioClient.post('/events.php', data: _map);
      return EventResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }

      return EventResponse.withError("$e");
    }
  }

  Future<bool> postQuery(Query query) async {
    Map _body = Map();
    _body['access_token'] = query.accessToken;
    _body['name'] = query.name;
    _body['phone_no'] = query.phoneNo;
    _body['email'] = query.email;
    _body['message'] = query.message;

    Response response = await _dioClient.post('/query.php', data: _body);
    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<bool> postFeedback(Feedback feedback) async {
    Map _body = Map();
    _body['access_token'] = feedback.accessToken;
    _body['name'] = feedback.name;
    _body['phone_no'] = feedback.phoneNo;
    _body['email'] = feedback.email;
    _body['message'] = feedback.message;
    _body['post_id'] = feedback.postId;
    _body['title'] = feedback.title;

    Response response =
        await _dioClient.post('/feedback_post.php', data: _body);
    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<bool> addBookmark(String accessToken, String postId) async {
    Map body = Map();
    body['access_token'] = accessToken;
    body['post_id'] = postId;

    Response response = await _dioClient.post('/bookmarks.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return true;
      } else {
        return Future.error(response.data['message']);
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<bool> deleteBookmark(String accessToken, String postId) async {
    Map body = Map();
    body['access_token'] = accessToken;
    body['post_id'] = postId;

    Response response =
        await _dioClient.post('/remove_bookmarks.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<List<BookmarkModel>> fetchBookmarks(String accessToken) async {
    Map body = Map();
    body['access_token'] = accessToken;

    Response response = await _dioClient.post('/getbookmarks.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data == "") {
        return Future.error("Servers have some issue, please try again later");
      }
      if (response.data['success'] == true) {
        var v = response.data['bookmarks'];
        List<BookmarkModel> bookmarks = List();
        for (int i = 0; i < v.length; i++) {
          bookmarks.add(BookmarkModel.fromJson(v[i]));
        }
        return bookmarks;
      } else {
        return [];
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<ByteResponse> fetchBytes(String accessToken) async {
    final _map = {'access_token': accessToken};
    try {
      Response response = await _dioClient.post('/bytes.php', data: _map);
      return ByteResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }

      return ByteResponse.withError("$e");
    }
  }

//  Future<List<BytesModel>> fetchBytes(String accessToken) async {
//    Map body = Map();
//    body['access_token'] = accessToken;
//
//    Response response = await _dioClient.post('/bytes.php', data: body);
//
//    if (response.statusCode == HttpStatus.ok) {
//      if (response.data == "") {
//        return Future.error("Servers have some issues");
//      }
//      if (response.data['success'] == true) {
//        var v = response.data['bytes'];
//        List<BytesModel> bytes = List();
//        for (int i = 0; i < v.length; i++) {
//          bytes.add(BytesModel.fromJson(v[i]));
//        }
//        return bytes;
//      } else {
//        return [];
//      }
//    } else {
//      return Future.error('Something Went Wrong');
//    }
//  }

  Future<List<NotificationModel>> fetchNotification(String accessToken) async {
    Map body = Map();
    body['access_token'] = '6173603745f1193f148eec7.70611480';

    Response response = await _dioClient
        .post('/get-notifications.php', data: body)
        .catchError((e) {});

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        var v = response.data['notifications'];
        List<NotificationModel> notifcations = List();
        for (int i = 0; i < v.length; i++) {
          notifcations.add(NotificationModel.fromJson(v[i]));
        }
        return notifcations;
      } else {
        return [];
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<User> fetchUser(String accessToken) async {
    Map body = Map();
    body['access_token'] = accessToken;

    Response response = await _dioClient.post('/user_fetch.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        var v = response.data['user'];
        return User.fromJson(v);
      } else {
        return Future.error("You token has been expired or wrong");
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<User> updateProfile(User user) async {
    print(user.toJson());
    Map body = Map();
    body['access_token'] = user.accessToken;
    body['name'] = user.name;
    body['dob'] = user.dob;
    body['email'] = user.email;
    body['phone_no'] = user.phoneNo;

    Response response =
        await _dioClient.post('/profile_update.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        var v = response.data['user'];
        return User.fromJson(v);
      } else {
        return Future.error(response.data['message']);
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<List<Search>> search(String keyword, String accessToken) async {
    Map body = Map();
    body['access_token'] = accessToken;
    body['keyword'] = keyword;

    Response response = await _dioClient.post('/searchget.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        var v = SearchResult.fromJson(response.data);
        return v.search;
      } else {
        return Future.error(response.data['message']);
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }



  String getErrorMsg(DioErrorType type) {
    switch (type) {
      case DioErrorType.CONNECT_TIMEOUT:
        // TODO: Handle this case.
        return "Connection timeout";
        break;
      case DioErrorType.SEND_TIMEOUT:
        // TODO: Handle this case.
        return "Send timeout";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        // TODO: Handle this case.
        return "Receive timeout";
        break;
      case DioErrorType.RESPONSE:
        // TODO: Handle this case.
        return "Response timeout";
        break;
      case DioErrorType.CANCEL:
        // TODO: Handle this case.
        return "Request has been cancelled";
        break;
      case DioErrorType.DEFAULT:
        // TODO: Handle this case.
        return "Could not connect";
        break;
      default:
        return "Something went wrong";
        break;
    }
  }
}
