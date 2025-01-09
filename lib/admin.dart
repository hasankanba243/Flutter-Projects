import 'package:flutter/material.dart';
import 'package:wallpaper/manageUser.dart';
import 'package:wallpaper/manageWallpapers.dart';

class admin extends StatefulWidget {
  const admin({super.key});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  var _curIndex = 0;
  var _pgcon = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      body: PageView(
        controller: _pgcon,
        onPageChanged: (value) {
          setState(() {
            _curIndex = value;
          });
        },
        children: [
          manageUser(),
          manageWallpapers(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIndex,
        onTap: (value) {
          setState(() {
            _curIndex = value;
          });
          _pgcon.animateToPage(_curIndex,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Users"),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_sharp), label: "Wallpapers"),
        ],
      ),
    );
  }
}
