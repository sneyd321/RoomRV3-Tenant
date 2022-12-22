import 'dart:io';

import 'package:camera_example/business_logic/list_items/additional_term.dart';
import 'package:camera_example/graphql/mutation_helper.dart';
import 'package:camera_example/graphql/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;


void main() {
  Widget getMutation(String responseFileName, String mutationName,
      dynamic Function(dynamic json) convert) {
    String result = "";
    String content =
        File("./test/responses/$responseFileName").readAsStringSync();
    return GraphQLProvider(
      client: GQLClient().getTestClient(HttpLink('https://unused/graphql',
          httpClient: MockClient((request) async {
        return http.Response(content, 200);
      }))),
      child: MaterialApp(
        home: MutationHelper(
          mutationName: mutationName,
          onComplete: (json) {
            dynamic data = convert(json);
            result = data.toJson().toString();
            printOnFailure(result);
          },
          builder: ((runMutation) {
            runMutation({});
            return SafeArea(child: Scaffold(body: Text(result)));
          }),
        ),
      ),
    );
  }


  Widget getMutationList(String responseFileName, String mutationName,
      dynamic Function(dynamic json) convert) {
    String result = "";
    String content =
        File("./test/responses/$responseFileName").readAsStringSync();
    return GraphQLProvider(
      client: GQLClient().getTestClient(HttpLink('https://unused/graphql',
          httpClient: MockClient((request) async {
        return http.Response(content, 200);
      }))),
      child: MaterialApp(
        home: MutationHelper(
          mutationName: mutationName,
          onComplete: (json) {
            dynamic data = convert(json);
            result = data.map((e) => e.toJson()).toList().toString();
            printOnFailure("Did it print?");
            printOnFailure(result);
          },
          builder: ((runMutation) {
            runMutation({});
            return SafeArea(child: Scaffold(body: Text(result)));
          }),
        ),
      ),
    );
  }

  setUpAll(() async {
    await initHiveForFlutter();
  });


  testWidgets("Mutation_helper_successfully_parses_additional_terms_on_update",
      (tester) async {
    Widget widget =
        getMutationList("not_authorized_403.json", "updateAdditionalTerms", (json) {
      return json.map<AdditionalTerm>((e) => CustomTerm.fromJson(e)).toList();
    });

    await tester.pumpWidget(widget);
    await tester.pump();
    await tester.pump();
    expect(find.textContaining("Missing Authorization header"), findsOneWidget);
  });


  


}
