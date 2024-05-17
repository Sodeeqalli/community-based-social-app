import 'package:bu_connect/core/constants/firebase_constants.dart';
import 'package:bu_connect/core/failure.dart';
import 'package:bu_connect/core/providers/firebase_providers.dart';
import 'package:bu_connect/core/type_defs.dart';
import 'package:bu_connect/models/comments_model.dart';
import 'package:bu_connect/models/community_model.dart';
import 'package:bu_connect/models/post_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Post.fromMap(
                e.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvote(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<void> addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      if (comment.postId != null) {
        _posts
            .doc(comment.postId)
            .update({'commentCount': FieldValue.increment(1)});
      } else {
        _comments.doc(comment.commentId).update({
          'replies': FieldValue.arrayUnion([comment.toMap()])
        });
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  FutureVoid deleteComment(Comment comment) async {
    try {
      return right(_comments.doc(comment.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getPostComments(String postId) {
    return _comments
        .orderBy('createdAt', descending: true)
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Comment.fromMap(
                e.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }

  Stream<List<Comment>> getCommentsReplies(String commentId) {
    return _comments
        .orderBy('createdAt', descending: true)
        .where('commentId', isEqualTo: commentId)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Comment.fromMap(
                e.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award])
      });
      _users.doc(senderId).update({
        'award': FieldValue.arrayRemove([award])
      });

      return right(_users.doc(post.uid).update({
        'award': FieldValue.arrayUnion([award])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
