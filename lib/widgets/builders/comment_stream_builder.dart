
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../business_logic/comment.dart';
import '../../business_logic/tenant.dart';
import '../cards/from_comment_card.dart';
import '../cards/to_comment_card.dart';
import '../listviews/CardSliverListView.dart';

class CommentStreamBuilder extends StatefulWidget {
  final ScrollController scrollController;
  final String firebaseId;
  final Tenant tenant;

  const CommentStreamBuilder(
      {Key? key, required this.scrollController, required this.firebaseId, required this.tenant})
      : super(key: key);

  @override
  _CommentStreamBuilderState createState() => _CommentStreamBuilderState();
}

class _CommentStreamBuilderState extends State<CommentStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("MaintenanceTicket")
            .doc(widget.firebaseId)
            .collection("Comment")
            .orderBy("timestamp")
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Text("Loading");
          }
          QuerySnapshot querySnapshot = snapshot.data!;
          return CardSliverListView(
            items: querySnapshot.docs,
            controller: widget.scrollController,
            noItemsText: "No Comments",
            builder: (BuildContext context, int index) {

              QueryDocumentSnapshot document = querySnapshot.docs[index];
              Comment comment = TextComment();
              
              switch (document.get("name")) {
                case "text":
                  comment = TextComment();
                  break;
                case "image":
                  comment = ImageComment();
                  break;
                
              }
              comment.setComment(document.get("comment"));
              comment.setEmail(document.get("email"));
              comment.setFirstName(document.get("firstName"));
              comment.setLastName(document.get("lastName"));
            
              return comment.email == widget.tenant.email ? ToCommentCard(comment: comment) : FromCommentCard(comment: comment);
            },
          );
          
          
          
        },
      ),
    );
  }
}
