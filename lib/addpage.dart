import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class addpage extends StatefulWidget {
  const addpage({super.key});

  @override
  State<addpage> createState() => _addpageState();
}

class _addpageState extends State<addpage> {
  XFile? _img;
  var title = TextEditingController();
  var desc = TextEditingController();
  var amount = TextEditingController();

  Future<void> pickImagefromGallery() async {
    final _pickedImage = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);
    if (_pickedImage != null) {
      setState(() {
        _img = _pickedImage;
      });
    }
    return null;
  }

  Future<void> pickImagefromCamera() async {
    final _pickedImage = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.camera);
    if (_pickedImage != null) {
      setState(() {
        _img = _pickedImage;
      });
    }
    return null;
  }

  // Future<void> uploadImage() async {
  //   await Supabase.instance.client.storage.from("Kanba Images").upload(
  //         "${_img!.name}",
  //         File(_img!.path),
  //       );
  // print(await Supabase.instance.client.storage
  //     .from("Kanba Images")
  //     .getPublicUrl("${_img!.name}"));

  Future<void> uploadImage() async {
    await Supabase.instance.client.storage.from("Kanba Images").upload(
          "${title.text.replaceAll(" ", "")}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}",
          File(_img!.path),
        );
    var url = await Supabase.instance.client.storage
        .from("Kanba Images")
        .getPublicUrl(
            "${title.text}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}");
    FirebaseFirestore.instance.collection("WallsTheme").add({
      "title": title.text,
      "description": desc.text,
      "imgurl": url,
      "date": DateTime.now(),
      "amount": int.parse(amount.text),
      "visible": true,
      "uid": FirebaseAuth.instance.currentUser!.uid
    }).then((value) {
      setState(() {
        _img = null;
        desc.text = "";
        title.text = "";
        amount.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image Uploaded"),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: pickImagefromGallery,
                  onLongPress: pickImagefromCamera,
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    child: _img == null
                        ? Center(
                            child: Text(" No Image Found"),
                          )
                        : Image.file(
                            File(_img!.path),
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Title :"),
                  ),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: desc,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Description :"),
                  ),
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: amount,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Amount :"),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: ElevatedButton(
                        onPressed: uploadImage, child: Text("Upload")),
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
