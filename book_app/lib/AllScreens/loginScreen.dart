import 'package:book_app/AllScreens/mainScreen.dart';
import 'package:book_app/AllScreens/signupScreen.dart';
import 'package:book_app/Widgets/progressDialog.dart';
import 'package:book_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 105.0,
              ),
              Center(
                child: Image(
                  image: AssetImage("images/book_bundle.png"),
                  width: 250.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Text(
                "LOGIN AS RIDER",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    RaisedButton(
                      color: Colors.orange.shade400,
                      textColor: Colors.white,
                      child: Container(
                        height: 60.0,
                        width: 200.0,
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0)),
                      onPressed: () {
                        if (!email.text.contains("@")) {
                          displayToastMessage(
                              "Email Address is not valid", context);
                        } else if (password.text.isEmpty) {
                          displayToastMessage(
                              "Password is mandatory ", context);
                        } else {
                          loginUser(context);
                        }
                      },
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignupScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not Have Account? Register here",
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait....",
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: email.text, password: password.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error:" + errMsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Welcome Back !!!!! ", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("No record Found, Please create new account", context);
        }
      });
    } else {
      //display error
      Navigator.pop(context);
      displayToastMessage("Error Occur,can not be signed in ", context);
    }
  }
}
displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
