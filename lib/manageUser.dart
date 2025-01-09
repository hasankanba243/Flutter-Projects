import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class manageUser extends StatefulWidget {
  const manageUser({super.key});

  @override
  State<manageUser> createState() => _manageUserState();
}

class _manageUserState extends State<manageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size < 0) {
              return Center(
                child: Text("No Data Found"),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((suser) {
                  return ListTile(
                    title: Text("${suser["username"]}"),
                    subtitle: Text("${suser["email"]}"),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage("${suser["pimg"]}"),
                    ),
                    trailing: IconButton(
                      icon: suser["pg"] == true
                          ? Icon(Icons.camera)
                          : Icon(Icons.person),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(suser.id)
                            .update({"pg": !suser["pg"]});
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
