import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:skype/Screens/search_screen.dart';
import 'package:skype/provider/Image_uploader.dart';
import 'package:skype/provider/user_provider.dart';
import 'package:skype/resourses/Storage_methods.dart';
import 'package:skype/resourses/Auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype/Screens/login_screen.dart';
import 'package:skype/Screens/home_screen.dart';

void main() {
  runApp(MyApp());
}
//keytool -list -v -keystore C:\Users\nikhil\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
// Firestore.instance.collection("users").document().setData({"name":"nikhil"});
//_repositiory.signOut();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ImageUploadProvider()),
        ChangeNotifierProvider(create: (_)=>UserProvider()),

      ],
          child: MaterialApp(
        title:"Skype Clone",
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
routes:{
  "/search_screen":(context)=>Search_Screen()
},
theme: ThemeData(brightness: Brightness.dark),
        home:  FutureBuilder(future:  _authMethods.getCurrentUser(),
        builder: (context,AsyncSnapshot<FirebaseUser> snapshot) 
        {
if(snapshot.hasData){
  return HomeScreen();
  }
  else{
      return Login_Screen();
  }
        },)
      ),
    );
  }
}
