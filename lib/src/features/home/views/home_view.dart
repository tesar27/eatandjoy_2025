import 'package:flutter/material.dart';
import 'package:enj/src/features/tab1/views/tab1_view.dart';
import 'package:enj/src/features/tab2/views/tab2_view.dart';
import 'package:enj/src/features/tab3/views/tab3_view.dart';
import 'package:enj/src/features/tab4/views/tab4_view.dart';
import 'package:enj/src/features/tab5/views/tab5_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Tab1View(),
    Tab2View(),
    Tab3View(),
    Tab4View(),
    Tab5View(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tab 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Tab 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Tab 3',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Tab 4',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tab 5',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
