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
import 'package:nityaassociation/network/api_provider.dart';

class Repository {
    final apiProvider = ApiProvider();

    Future<SignResponse> signUp(String name, String phone) =>
        apiProvider.signUp(name, phone);

  Future<dynamic> verifySignedUpOtp(String otp, String phone) =>
      apiProvider.verifySignUpOtp(otp, phone);

  Future<LoginResponse> login(String phone) => apiProvider.login(phone);

  Future<dynamic> verifyLoginOtp(String otp, String phone) =>
      apiProvider.verifyLoginOtp(otp, phone);

  Future<dynamic> resendOTP(int isPhoneVerified, String phone) =>
      apiProvider.resendOTP(phone, isPhoneVerified);

  Future<PostResponse> fetchPosts(String accessToken) =>
      apiProvider.fetchPosts(accessToken);

  Future<EventResponse> fetchEvents(String accessToken) =>
      apiProvider.fetchEvents(accessToken);

  Future<bool> postQuery(Query query) => apiProvider.postQuery(query);

  Future<bool> postFeedback(Feedback feedback) =>
      apiProvider.postFeedback(feedback);

  Future<bool> addBookmark(String token, String id) =>
      apiProvider.addBookmark(token, id);

  Future<bool> removeBookmark(String token, String id) =>
      apiProvider.deleteBookmark(token, id);

  Future<List<BookmarkModel>> fetchBookmarks(String token) =>
      apiProvider.fetchBookmarks(token);

  Future<ByteResponse> fetchBytes(String token) =>
      apiProvider.fetchBytes(token);

  Future<List<NotificationModel>> fetchNotifications(String token) =>
      apiProvider.fetchNotification(token);

  Future<User> updateUser(User user) => apiProvider.updateProfile(user);

  Future<List<Search>> search(String keyword, String accessToken) =>
      apiProvider.search(keyword, accessToken);
}
