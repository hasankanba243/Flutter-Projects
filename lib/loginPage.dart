import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/admin.dart';
import 'package:wallpaper/homePage.dart';
import 'package:wallpaper/registerPage.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  var _email = TextEditingController();
  var _pass = TextEditingController();
  var _obtext = true;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;
      FirebaseFirestore.instance.collection("Users").doc(user?.uid).set({
        "username": user!.displayName,
        "email": user!.email,
        "pass": null,
        "pg": false,
        "pimg": "${user.photoURL}"
      }).then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", user.uid);
        prefs.setString("username", user.displayName.toString());
        prefs.setString("email", user.email.toString());
        prefs.setBool("islogin", true);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User Logged In")));

        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => homePage()));
      });
    }
  }

  void checklogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("islogin") == true) {
      if (prefs.getBool("isadmin") == true) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => admin(),
        ));
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => homePage(),
        ));
      }
    }
  }

// Starts when page is initialized
  @override
  void initState() {
    checklogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "Enter E-Mail : ",
                  hintText: "example@gmail.com",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.mail_outline),
                  labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                  prefixIconColor: Colors.deepPurpleAccent),
            ),
            SizedBox(
              height: 14,
            ),
            TextFormField(
              controller: _pass,
              decoration: InputDecoration(
                labelText: "Enter Password : ",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.password),
                prefixIconColor: Colors.deepPurpleAccent,
                labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                suffix: InkWell(
                  onTapDown: (_) {
                    setState(() {
                      _obtext = false;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _obtext = true;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _obtext = true;
                    });
                  },
                  child: Icon(
                    _obtext ? Icons.visibility : Icons.visibility_off,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
              obscureText: _obtext,
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  var email = _email.text.toString();
                  var password = _pass.text.toString();
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password)
                      .then((users) async {
                    if (email == "admin@wallsbynode.com" &&
                        password == "Admin@123") {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("isadmin", true);
                      prefs.setBool("islogin", true);

                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => admin(),
                      ));
                    } else {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(users.user?.uid)
                          .get()
                          .then((value) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("uid", value.id);
                        prefs.setString("username", value["username"]);
                        prefs.setString("email", value["email"]);
                        prefs.setString("pass", value["pass"]);
                        prefs.setBool("islogin", true);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("User Logged In")));
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => homePage(),
                      ));
                    }
                  }).catchError((err) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("${err}")));
                  });
                },
                child: Text("Login"),
              ),
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
                Text("New To Here ?"),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => registerPage(),
                      ));
                    },
                    child: Text("Register"))
              ],
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
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  signup(context);
                },
                child: Text("Sign In With Google"))
          ]),
        ),
      ),
    );
  }
}
