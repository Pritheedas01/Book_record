import 'package:book_app/AllScreens/filterScreen.dart';
import 'package:book_app/AllScreens/loginScreen.dart';
import 'package:book_app/AllScreens/mainScreen.dart';
import 'package:book_app/AllScreens/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("user");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final primaryColor = const Color(0xFF151026);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange.shade400
      ),
      initialRoute: MainScreen.idScreen,
      routes: {
        SignupScreen.idScreen:(context)=>SignupScreen(),
        LoginScreen.idScreen:(context)=>LoginScreen(),
        MainScreen.idScreen:(context)=>MainScreen(),
        FilterScreen.idScreen:(context)=>FilterScreen()

      },
      debugShowCheckedModeBanner: false,
    );
  }
}

