import 'dart:io';

import 'package:camera_example/business_logic/address.dart';
import 'package:camera_example/business_logic/list_items/service.dart';
import 'package:camera_example/business_logic/maintenance_ticket.dart';
import 'package:camera_example/business_logic/rent.dart';
import 'package:camera_example/business_logic/tenancy_terms.dart';
import 'package:camera_example/business_logic/tenant.dart';
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

 



  testWidgets("Mutation_helper_successfully_parses_tenant_on_create_tenant",
      (tester) async {
    Widget widget =
        getMutation("create_tenant_200.json", "createTenant", (json) {
      return Tenant.fromJson(json);
    });

    await tester.pumpWidget(widget);
    await tester.pump();
    await tester.pump();
    expect(find.textContaining("Ryan"), findsOneWidget);
  });

  testWidgets(
      "Mutation_helper_successfully_parses_maintenance_ticket_on_create_maitnenance_ticket",
      (tester) async {
    Widget widget = getMutation(
        "create_maintenance_ticket_200.json", "createMaintenanceTicket",
        (json) {
      return MaintenanceTicket.fromJson(json);
    });

    await tester.pumpWidget(widget);
    await tester.pump();
    await tester.pump();
    expect(find.textContaining("fdagfdasfsdfasdfa"), findsOneWidget);
  });

  testWidgets("Mutation_helper_successfully_parses_tenant_on_login",
      (tester) async {
    Widget widget = getMutation("login_tenant_200.json", "loginTenant", (json) {
      return Tenant.fromJson(json);
    });

    await tester.pumpWidget(widget);
    await tester.pump();
    await tester.pump();
    expect(find.textContaining("Ryan"), findsOneWidget);
  });

  


}

