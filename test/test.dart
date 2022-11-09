import 'package:camera_example/business_logic/timestamp.dart';
import 'package:camera_example/business_logic/urgency.dart';
import 'package:camera_example/services/maintenance_ticket_facade.dart';
import 'package:camera_example/business_logic/description.dart' as test_description;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Validate Singleton is same instance.', () {
    MaintenanceTicketFacade facade1 = MaintenanceTicketFacade();
    MaintenanceTicketFacade facade2 = MaintenanceTicketFacade();
    expect(facade1 == facade2, true);

  });


  test('Validate Description is saved in maintenance ticket', () {
    MaintenanceTicketFacade facade = MaintenanceTicketFacade();
    facade.setDescription(test_description.Description("description"));
    expect(facade.getMaintenanceTicket()!.description!.description == "description", true);
  });


  test('Validate Low Urgency is saved in maintenance ticket', () {
    MaintenanceTicketFacade facade = MaintenanceTicketFacade();
    facade.setUrgency(LowUrgency());
    expect(facade.getMaintenanceTicket()!.urgency!.name == "Low", true);
  });

   test('Validate Medium Urgency is saved in maintenance ticket', () {
    MaintenanceTicketFacade facade = MaintenanceTicketFacade();
    facade.setUrgency(MediumUrgency());
    expect(facade.getMaintenanceTicket()!.urgency!.name == "Medium", true);
  });

  test('Validate High Urgency is saved in maintenance ticket', () {
    MaintenanceTicketFacade facade = MaintenanceTicketFacade();
    facade.setUrgency(HighUrgency());
    expect(facade.getMaintenanceTicket()!.urgency!.name == "High", true);
  });

  test('Validate timestamp parser parses correctly', () {
    Timestamp timestamp = Timestamp();
    String actual = timestamp.parseDateCreated("2022-01-06");
    printOnFailure(actual);
    expect(actual == "2022-01-06", true);
  });

  test('Validate timestamp parser parses correctly with date greater than 10', () {
    Timestamp timestamp = Timestamp();
    String actual = timestamp.parseDateCreated("2022-11-16");
    printOnFailure(actual);
    expect(actual == "2022-11-16", true);
  });


}