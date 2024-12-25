import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/loginPage.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  bool pg = false;

  void checkpg() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        pg = value["pg"];
      });
    });
  }

  @override
  void initState() {
    checkpg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => loginPage(),
              ));
            },
            child: Text("Logout"),
          ),
        ),
        floatingActionButton: pg
            ? FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              )
            : SizedBox());
  }
}
