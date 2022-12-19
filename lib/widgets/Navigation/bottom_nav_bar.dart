
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
        Navigation().navigateToProfilePage(context, widget.tenant, widget.house);
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
                  child: Icon(Icons.dashboard, color: Colors.black,),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.account_circle, color: Colors.black,),
                  ),
                  label: "Account"),
            ],
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
          );
  }
}