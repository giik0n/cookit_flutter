import 'package:cookit/models/User.dart';
import 'package:cookit/screens/addRecipe.dart';
import 'package:cookit/screens/feed.dart';
import 'package:cookit/screens/search.dart';
import 'package:cookit/screens/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var labels = ["Search", "Feed", "Profile"];
  int _selectedIndex = 1;
  List<Widget> bodys = [Search(), Feed(), Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(labels[_selectedIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: labels[0]),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: labels[1]),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: labels[2]),
        ],
      ),
      body: bodys[_selectedIndex],
      floatingActionButton: (_selectedIndex == 1)
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRecipe()),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
