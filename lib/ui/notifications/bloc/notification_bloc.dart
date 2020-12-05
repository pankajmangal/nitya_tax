import 'package:nityaassociation/model/notification_model.dart';
import 'package:nityaassociation/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class NotificationBloc extends BaseBloc {
  static final NotificationBloc _notificationBloc =
      NotificationBloc._internal();

  factory NotificationBloc() {
    return _notificationBloc;
  }

  NotificationBloc._internal();

  final _notificationStream = BehaviorSubject<List<NotificationModel>>();
  final _notificationErrorStream = PublishSubject<String>();

  Stream<List<NotificationModel>> get notifications =>
      _notificationStream.stream;

  Stream<String> get notificationsError => _notificationErrorStream.stream;

  getNotifications(String accessToken) async {
    await repository.fetchNotifications(accessToken).catchError((e) {
      print(e);
      _notificationErrorStream.sink.add(e.toString());
    }).then((value) {
      if (value != null) _notificationStream.sink.add(value);
    });
  }

  dispose() {
    _notificationStream.close();
    _notificationErrorStream?.close();
  }
}
