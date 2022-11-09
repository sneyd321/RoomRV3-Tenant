

import 'package:camera_example/business_logic/comment.dart';
import 'package:camera_example/services/comment_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentFacade {


  static final CommentFacade _singleton = CommentFacade._internal();

  factory CommentFacade() {
    return _singleton;
  }


  final CommentRepository commentRepository = CommentRepository();

  CommentFacade._internal();

  
  void setTextComment(TextComment textComment) {
    commentRepository.setTextComment(textComment);
  }
  
  Comment getComment() {
    return commentRepository.comment!;
  }

  Future<void> save(String firebaseId) async {
    return commentRepository.save(firebaseId);
  }

  Stream<DocumentSnapshot> load(String firebaseId) {
    return commentRepository.load(firebaseId);
  }

}