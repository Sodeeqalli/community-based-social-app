class Message {
  final String messageId;
  final DateTime timeStamp;
  final String text;
  final String senderId;
  final String receiverId;
  final bool isForwarded;
  final bool viewOnce;

  Message({
    required this.messageId,
    required this.timeStamp,
    required this.text,
    required this.senderId,
    required this.receiverId,
    this.isForwarded = false,
    this.viewOnce = false, // Default value set to false
  });

  Message copyWith({
    String? messageId,
    DateTime? timeStamp,
    String? text,
    String? senderId,
    String? receiverId,
    bool? isForwarded,
    bool? viewOnce, // Added for viewOnce
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      timeStamp: timeStamp ?? this.timeStamp,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      isForwarded: isForwarded ?? this.isForwarded,
      viewOnce: viewOnce ?? this.viewOnce, // Added for viewOnce
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'isForwarded': isForwarded,
      'viewOnce': viewOnce, // Added for viewOnce
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'] as String,
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int),
      text: map['text'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      isForwarded: map['isForwarded'] as bool? ?? false,
      viewOnce: map['viewOnce'] as bool? ?? false, // Added for viewOnce
    );
  }

  @override
  String toString() {
    return 'Message(messageId: $messageId, timeStamp: $timeStamp, text: $text, senderId: $senderId, receiverId: $receiverId, isForwarded: $isForwarded, viewOnce: $viewOnce)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.messageId == messageId &&
        other.timeStamp == timeStamp &&
        other.text == text &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.isForwarded == isForwarded &&
        other.viewOnce == viewOnce; // Added for viewOnce
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        timeStamp.hashCode ^
        text.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        isForwarded.hashCode ^
        viewOnce.hashCode; // Added for viewOnce
  }
}
