

import 'package:camera_example/widgets/cards/to_comment_card.dart';
import 'package:flutter/material.dart';

class CommentListView extends StatefulWidget {

  final List comments;
  final ScrollController scrollController;

  const CommentListView({Key? key, required this.comments, required this.scrollController}) : super(key: key);

  @override
  State<CommentListView> createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView> {
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
      itemCount: widget.comments.length,
      controller: widget.scrollController,
      itemBuilder: (context, index) {
        return ToCommentCard(comment: widget.comments[index]);
      },
    );
  }
}