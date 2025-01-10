import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/addpage.dart';
import 'package:wallpaper/userWalls.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  bool pg = false;
  List menuitems = ["Profile", "My Wallpapers"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Walls By Node"),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton(onSelected: (value) {
            switch (value) {
              case "profile":
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => addpage(),
                ));
                break;
              case "mywalls":
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => userWalls(),
                ));
                break;
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem(child: Text("Profile"), value: "profile"),
              PopupMenuItem(child: Text("My Wallpapers"), value: "mywalls"),
            ];
          })
        ],
      ),
      body: Center(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("WallsTheme")
            .where("visible", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size < 0) {
              return Center(
                child: Text("No Data Found"),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1 / 1.3),
                  children: snapshot.data!.docs.map((sdata) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            color: Colors.blue,
                            child: CachedNetworkImage(
                              imageUrl: sdata["imgurl"],
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(13, 3, 0, 8),
                          child: Chip(
                              label: Icon(
                            sdata["amount"] > 0
                                ? Icons.currency_rupee
                                : Icons.download_outlined,
                            size: 14,
                          )),
                        )
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )),
      floatingActionButton: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(); // Optional: Add a loading indicator
          }

          if (snapshot.hasError) {
            return SizedBox(); // Optional: Handle error state
          }

          // Check if snapshot has data and `pg` exists
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            bool pg = data["pg"] ?? false;

            return pg
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => addpage(),
                      ));
                    },
                    child: Icon(Icons.add),
                  )
                : SizedBox();
          }

          return SizedBox();
        },
      ),
    );
  }
}

// ElevatedButton(
//             onPressed: () async {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               prefs.clear();
//               Navigator.of(context).pop();
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => loginPage(),
//               ));
//             },
//             child: Text("Logout"),
//           ),
