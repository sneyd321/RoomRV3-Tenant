
import 'package:camera_example/business_logic/house.dart';
import 'package:flutter/material.dart';

import '../../business_logic/tenant.dart';
import 'navigation.dart';


class BottomNavBar extends StatefulWidget {
  final Tenant tenant;
  final House house;
  const BottomNavBar({Key? key, required this.tenant, required this.house}) : super(key: key);


  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigation().navigateToDashboardPage(context, widget.tenant, widget.house);
          break;
        case 1:
        Navigation().navigateToMorePage(context, widget.house, widget.tenant);
          break;
        default:
        Navigation().navigateToDashboardPage(context, widget.tenant, widget.house);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
       
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.notifications, color: Colors.black,),
                ),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.list, color: Colors.black,),
                  ),
                  label: "More"),
            ],
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
          );
  }
}