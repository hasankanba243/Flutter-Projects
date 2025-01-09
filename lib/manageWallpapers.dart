import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class manageWallpapers extends StatefulWidget {
  const manageWallpapers({super.key});

  @override
  State<manageWallpapers> createState() => _manageWallpapersState();
}

class _manageWallpapersState extends State<manageWallpapers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("WallsTheme")
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size < 0) {
              return Center(
                child: Text("No Data Found"),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((walls) {
                  return ListTile(
                    title: Text("${walls["title"]}"),
                    subtitle: Text(
                      "${walls["amount"] > 0 ? (walls["amount"] * 0.20).toString() + " Profit" : " Free"}",
                      style: TextStyle(color: Colors.green),
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
