import 'package:camera_example/services/notification/download_lease_notification.dart';
import 'package:camera_example/widgets/Buttons/PrimaryButton.dart';
import 'package:camera_example/widgets/Buttons/SecondaryButton.dart';
import 'package:camera_example/widgets/cards/download_lease_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../business_logic/house.dart';

class DashboardPage extends StatefulWidget {
  final House house;
  const DashboardPage({Key? key, required this.house}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double getProgress() {
    int daysInCurrentMonth =
        widget.house.lease.tenancyTerms.getLastDayInMonth();
    int daysUntilRentIsDue =
        widget.house.lease.tenancyTerms.getDaysUntilRentIsDue();
    int daysLeft = daysInCurrentMonth - daysUntilRentIsDue;
    return daysLeft / daysInCurrentMonth;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ListView(
        shrinkWrap: true,
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
                        tween: Tween<double>(begin: 0.0, end: getProgress()),
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
                          "${widget.house.lease.tenancyTerms.getDaysUntilRentIsDue()}\ndays left",
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
                          widget.house.lease.tenancyTerms.getDateRentIsDue(),
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
                        Text(
                            "\$${widget.house.lease.rent.getTotalLawfulRent()}",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    )),
                
              ],
            ),
          ),
          Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(children: [
                    Container(
                    margin: const EdgeInsets.only(left: 8, top: 16),
                    child: Row(
                      children: [
                        const Text("Address Line 1: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SelectableText(
                            widget.house.lease.rentalAddress.getPrimaryAddress(),
                            style: const TextStyle(fontSize: 16)),
                      ],
                    )),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Text("Address Line 2: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SelectableText(
                              widget.house.lease.rentalAddress.unitName,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Text("City: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SelectableText(
                              widget.house.lease.rentalAddress.city,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Text("Province: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SelectableText(
                              widget.house.lease.rentalAddress.province,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, bottom: 16),
                      child: Row(
                        children: [
                          const Text("Postal Code: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SelectableText(
                              widget.house.lease.rentalAddress.postalCode,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    SecondaryButton(Icons.copy, "Copy Full Address", (context) async {
                      String addressToCopy = "${widget.house.lease.rentalAddress.getPrimaryAddress()} ${widget.house.lease.rentalAddress.getSecondaryAddress()}";
                      await Clipboard.setData(ClipboardData(text: addressToCopy));
                    })
                  ]),
                ),
                DownloadLeaseNotificationCard(documentURL: widget.house.lease.documentURL,)
        ],
      ),
    ));
  }
}
