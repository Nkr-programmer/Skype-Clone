import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:skype/resourses/Storage_methods.dart';
import 'package:skype/resourses/Auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype/Screens/home_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype/utils/universal_variables.dart';

class Login_Screen extends StatefulWidget {
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  AuthMethods _authMethods =AuthMethods();
bool isLoginPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body:Stack(children:[ Center(child: loginButton()
      ),
      isLoginPressed?Center(child: CircularProgressIndicator(),):Container()
      ]),
    );
  }
  Widget loginButton(){
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
          child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text("Login",
        style: TextStyle(fontSize: 35,fontWeight: FontWeight.w700,letterSpacing: 1.2),),
        onPressed: () => performLogin(),
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))
            ),
    );
        }
      
 void    performLogin() {

 print("trying to login");
 setState(() {
   isLoginPressed=true;
 });

   _authMethods.signIn().then((FirebaseUser user) {
      print("something");
if(user != null){
  authenticateUser(user);
}else{
  print("There was an error");
}

   });
 }
 void authenticateUser(FirebaseUser user)
{
_authMethods.authenticateUser(user).then((isNewUser) {
  setState(() {
    isLoginPressed=false;
  });
  if(isNewUser){
    _authMethods.addDataToDb(user).then((value){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  return HomeScreen();
  },));});
  }
  else{
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  return HomeScreen();
  },));
  }
});
}}