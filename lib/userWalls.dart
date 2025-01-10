import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class userWalls extends StatefulWidget {
  const userWalls({super.key});

  @override
  State<userWalls> createState() => _userWallsState();
}

class _userWallsState extends State<userWalls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wallpapers"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("WallsTheme")
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size < 0) {
              return Center(
                child: Text("Let's Upload Some Images"),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((walls) {
                  return ListTile(
                    title: Text("${walls["title"]}"),
                    subtitle: Text(
                      "${walls["description"]}",
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage("${walls["imgurl"]}"),
                    ),
                    trailing: IconButton(
                      icon: walls["visible"] == true
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("WallsTheme")
                            .doc(walls.id)
                            .update({"visible": !walls["visible"]});
                      },
                    ),
                  );
                }).toList(),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
