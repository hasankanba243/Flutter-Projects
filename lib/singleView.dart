import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class singleView extends StatefulWidget {
  final id;

  const singleView({super.key, required this.id});

  @override
  State<singleView> createState() => _singleViewState();
}

class _singleViewState extends State<singleView> {
  var imgurl = "";
  var title = "";
  var amount = 0;
  var desc = "";

  void getSingleData() {
    FirebaseFirestore.instance
        .collection("WallsTheme")
        .doc(widget.id)
        .get()
        .then((value) {
      print(value);
      setState(() {
        imgurl = value["imgurl"];
        title = value["title"];
        desc = value["description"];
        amount = value["amount"];
      });
    });
  }

  @override
  void initState() {
    getSingleData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: imgurl,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 200,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Center(
            child: Icon(
              Icons.warning,
              color: Colors.red,
              size: 30,
            ),
          ),
        ),
        Scaffold(
          bottomSheet: BottomSheet(
            builder: (context) {
              return Container(
                color: Colors.white,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${title}",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${desc}",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text("Amount : ${amount > 0 ? amount : "Free"}"),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: amount > 0
                                  ? Text(" Buy Now")
                                  : Text("Download"),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            onClosing: () {},
          ),
        )
      ],
    );
  }
}
