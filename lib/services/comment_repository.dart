

import 'package:camera_example/business_logic/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentRepository {


    Comment? comment;
  
    CommentRepository();

    void setTextComment(TextComment textComment) {
      comment = textComment;
    }

    void setImageComment(ImageComment imageComment) {
      comment = imageComment;
    }

    Future<void> save(String firebaseId) async {
      if (comment == null) {
        return Future.error("Comment not found");
      }
      DocumentReference documentReference = FirebaseFirestore.instance.collection('MaintenanceTicket').doc(firebaseId);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      var document = documentSnapshot.data()! as Map<String, dynamic>;
      var comments = document["comments"];
      comments.add(comment!.toJson());
      return documentReference.update({"comments": comments});
    }

    Stream<DocumentSnapshot> load(String firebaseId) {
      return FirebaseFirestore.instance.collection('MaintenanceTicket').doc(firebaseId).snapshots();
    }

  


}