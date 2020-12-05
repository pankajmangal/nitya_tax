class NotificationModel {
  String notificationId;
  String type;
  String userId;
  String title;
  String date;
  String message;
  String image;
  String action;
  String actionDestination;
  String markRead;

  NotificationModel(
      {this.notificationId,
      this.type,
      this.userId,
      this.title,
      this.date,
      this.message,
      this.image,
      this.action,
      this.actionDestination,
      this.markRead});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    type = json['type'];
    userId = json['user_id'];
    title = json['title'];
    date = json['date'];
    message = json['message'];
    image = json['image'];
    action = json['action'];
    actionDestination = json['action_destination'];
    markRead = json['mark_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['type'] = this.type;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['date'] = this.date;
    data['message'] = this.message;
    data['image'] = this.image;
    data['action'] = this.action;
    data['action_destination'] = this.actionDestination;
    data['mark_read'] = this.markRead;
    return data;
  }
}
