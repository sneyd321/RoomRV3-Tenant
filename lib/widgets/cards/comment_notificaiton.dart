import 'package:camera_example/business_logic/_picture.dart';
import 'package:camera_example/business_logic/maintenance_ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentNotification extends StatefulWidget {
  const CommentNotification({Key? key}) : super(key: key);

  @override
  State<CommentNotification> createState() => _CommentNotificationState();
}

class _CommentNotificationState extends State<CommentNotification> {

 

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: Icon(
            Icons.account_circle,
            size: 40,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Timmy Tenant", style: TextStyle(fontSize: 16, color: Colors.black, ),),
                Text("This is a comment", style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ),
        IconButton(onPressed: () {

        }, icon: Icon(Icons.comment, color: Colors.blue,))
      ],

    ));
  }
}
