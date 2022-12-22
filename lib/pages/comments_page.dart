import 'package:camera_example/business_logic/tenant.dart';
import 'package:camera_example/graphql/query_helper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../business_logic/maintenance_ticket.dart';
import '../services/FirebaseConfig.dart';
import '../graphql/graphql_client.dart';

import '../widgets/builders/comment_stream_builder.dart';
import '../widgets/forms/comment_form.dart';

class CommentsPage extends StatefulWidget {
  final int maintenanceTicketId;
  final String houseKey;
  final Tenant tenant;
  const CommentsPage(
      {Key? key,
      required this.maintenanceTicketId,
      required this.houseKey,
      required this.tenant})
      : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final ScrollController _scrollController = ScrollController();

  void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 2000));
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GQLClient().getClient(),
        child: SafeArea(
            child: Scaffold(
                appBar: AppBar(),
                body: QueryHelper(
                    isList: false,
                    queryName: 'getMaintenanceTicket',
                    variables: {
                      "houseKey": widget.houseKey,
                      "maintenanceTicketId": widget.maintenanceTicketId
                    },
                    onComplete: (json) {
                      if (json == null) {
                        return const CircularProgressIndicator();
                      }
                      MaintenanceTicket maintenanceTicket =
                          MaintenanceTicket.fromJson(json);

                      return Column(children: [
                        Expanded(
                            child: CommentStreamBuilder(
                          tenant: widget.tenant,
                          firebaseId: maintenanceTicket.firebaseId,
                          scrollController: _scrollController,
                        )),
                        CommentForm(
                          tenant: widget.tenant,
                          houseKey: widget.houseKey,
                          maintenanceTicket: maintenanceTicket,
                          onSend: (context, comment) async {
                            await FirebaseConfiguration().setComment(
                                maintenanceTicket.firebaseId, comment);
                            closeKeyboard(context);
                            scrollToBottom();
                          },
                        )
                      ]);
                    }))));
  }
}
