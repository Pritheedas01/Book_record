import 'package:book_app/AllScreens/loginScreen.dart';
import 'package:book_app/AllScreens/mainScreen.dart';
import 'package:book_app/Widgets/progressDialog.dart';
import 'package:book_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SignupScreen extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  static const String idScreen ="signup";
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
            height: 80.0,
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
            height: 30.0,
          ),
          Text(
            "SIGNUP",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Name",
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
                  height: 10.0,
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
                  height: 10.0,
                ),
                TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone",
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
                  height: 10.0,
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
                  height: 30.0,
                ),
                RaisedButton(
                  color: Colors.orange.shade400,
                  textColor: Colors.white,
                  child: Container(
                    height: 60.0,
                    width: 200.0,
                    child: Center(
                      child: Text(
                        "SIGNUP",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0)),
                  onPressed: () {
                    if(name.text.length < 3)
                    {
                      displayToastMessage("name must be at least 3 character", context);
                    }
                    else if(!email.text.contains("@"))
                    {
                      displayToastMessage("Email Address is not valid", context);
                    }
                    else if(phone.text.isEmpty)
                    {
                      displayToastMessage("Phone Number is mandatory ", context);
                    }
                    else if(password.text.length < 6)
                    {
                      displayToastMessage("Password must be at least 6 Character", context);
                    }
                    else
                    {
                      registerNewUser(context);
                    }

                  },
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.idScreen, (route) => false);
            },
            child: Text(
              "Already Have An Account? Login here",
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
  void registerNewUser(BuildContext context) async {
    showDialog(context: context,barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registering, Please wait....",);
        });

    final User firebaseUser =  (await _firebaseAuth.
    createUserWithEmailAndPassword(
        email:email.text,
        password:password.text).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error:" +errMsg.toString(), context);
    })).user;
    if(firebaseUser!= null)
    {
      //save user info into the firebase
      usersRef.child(firebaseUser.uid);
      Map userDataMap ={
        "name":name.text.trim(),
        "email":email.text.trim(),
        "phone":phone.text.trim(),
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulation, your account has been created", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }
    else
    {
      //display error
      displayToastMessage("New user account has not been created", context);
    }
  }

}
displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
