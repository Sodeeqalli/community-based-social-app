class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final String type;
  final String receiverId;
  final String senderId;
  final String?
      path; // Renamed from postId to path, and its purpose can be more general

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.type,
    required this.receiverId,
    required this.senderId,
    this.path, // Updated to path
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? date,
    String? type,
    String? receiverId,
    String? senderId,
    String? path, // Updated parameter name to path
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
      type: type ?? this.type,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      path: path ?? this.path, // Include path in the copied object
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'date': date.millisecondsSinceEpoch,
      'type': type,
      'receiverId': receiverId,
      'senderId': senderId,
      'path': path, // Include path in the map
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      type: map['type'] as String,
      receiverId: map['receiverId'] as String,
      senderId: map['senderId'] as String,
      path: map['path'] as String?, // Updated to path, can be null
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, date: $date, type: $type, receiverId: $receiverId, senderId: $senderId, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        id == other.id &&
        title == other.title &&
        body == other.body &&
        date == other.date &&
        type == other.type &&
        receiverId == other.receiverId &&
        senderId == other.senderId &&
        path == other.path; // Include path in equality check
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        date.hashCode ^
        type.hashCode ^
        receiverId.hashCode ^
        senderId.hashCode ^
        path.hashCode; // Include path in hash code calculation
  }
}
