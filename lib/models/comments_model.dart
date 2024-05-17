class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String? postId;
  final String username;
  final String profilePic;
  final String? commentId;
  final String userId; // Added userId property

  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    this.postId,
    required this.username,
    required this.profilePic,
    this.commentId,
    required this.userId, // Make userId a required parameter
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profilePic,
    String? commentId,
    String? userId, // Added userId for the copyWith method
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId, // Assign the new or existing userId
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
      'commentId': commentId,
      'userId': userId, // Include userId in the map
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String?,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
      commentId: map['commentId'] as String?,
      userId: map['userId'] as String, // Retrieve userId from the map
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic, commentId: $commentId, userId: $userId)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.username == username &&
        other.profilePic == profilePic &&
        other.commentId == commentId &&
        other.userId == userId; // Include userId in equality check
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        profilePic.hashCode ^
        commentId.hashCode ^
        userId.hashCode; // Include userId in hash code calculation
  }
}
