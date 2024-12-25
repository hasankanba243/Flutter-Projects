import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/loginPage.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  var _name = TextEditingController();
  var _email = TextEditingController();
  var _pass = TextEditingController();
  var _cpass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(labelText: "Enter Username : "),
                ),
                SizedBox(
                  height: 14,
                ),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Enter E-Mail : "),
                ),
                SizedBox(
                  height: 14,
                ),
                TextFormField(
                  controller: _pass,
                  decoration: InputDecoration(labelText: "Enter Password : "),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(
                  height: 14,
                ),
                TextFormField(
                  controller: _cpass,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: "Enter Confirm Password : "),
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(
                  height: 14,
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    var name = _name.text.toString();
                    var email = _email.text.toString();
                    var pass = _pass.text.toString();
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: pass)
                        .then((users) => {
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(users.user?.uid)
                                  .set({
                                "username": name,
                                "email": email,
                                "pass": pass,
                                "pg": false,
                                "pimg":
                                    "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg"
                              }).then((value) => {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("User Signed Up"),
                                          showCloseIcon: true,
                                        ))
                                      })
                            });
                  },
                  icon: Icon(Icons.login),
                  label: Text("SignUp"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 130,
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      Text("OR"),
                      Container(
                        width: 130,
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already A User ?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => loginPage(),
                          ));
                        },
                        child: Text("Login"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
