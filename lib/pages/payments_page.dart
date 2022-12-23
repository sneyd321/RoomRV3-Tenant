import 'package:camera_example/business_logic/house.dart';
import 'package:flutter/material.dart';

class PaymentsPage extends StatelessWidget {
  final House house;
  const PaymentsPage({Key? key, required this.house}) : super(key: key);


  double getProgress(House house) {
    int daysInCurrentMonth = house.lease.tenancyTerms.getLastDayInMonth();
    int daysUntilRentIsDue = house.lease.tenancyTerms.getDaysUntilRentIsDue();
    int daysLeft = daysInCurrentMonth - daysUntilRentIsDue;
    return daysLeft / daysInCurrentMonth;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 16),
                      child: TweenAnimationBuilder<double>(
                        tween:
                            Tween<double>(begin: 0.0, end: getProgress(house)),
                        duration: const Duration(milliseconds: 3500),
                        builder: (context, value, _) => SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 10,
                            backgroundColor: Colors.blue,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.orange),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 60),
                        alignment: Alignment.center,
                        child: Text(
                          "${house.lease.tenancyTerms.getDaysUntilRentIsDue()}\ndays left",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ))
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 16, left: 8),
                    child: Row(
                      children: [
                        const Text(
                          "Rent is due on: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          house.lease.tenancyTerms.getDateRentIsDue(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )),
                Container(
                    margin: const EdgeInsets.only(left: 8, bottom: 16),
                    child: Row(
                      children: [
                        const Text("Amount Due: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("\$${house.lease.rent.getTotalLawfulRent()}",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    )),
              ],
            ),
          ),
          const Card(
            child: ListTile(title: Text("Upcoming Payments coming soon")))
        ],
      ),
    ));
  }
}
