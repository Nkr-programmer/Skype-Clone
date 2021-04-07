import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype/Screens/chat_screen.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resourses/Storage_methods.dart';
import 'package:skype/resourses/Auth_methods.dart';
import 'package:skype/utils/universal_variables.dart';
import 'package:skype/widgets/custom_tile.dart';

class Search_Screen extends StatefulWidget {
  @override
  _Search_ScreenState createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  AuthMethods _authMethods =AuthMethods();
List<User> userList;
String query="";
TextEditingController searchController= TextEditingController();

@override
  void initState() {
    
    _authMethods.getCurrentUser().then((FirebaseUser user){
      _authMethods.fetchAllUsers(user).then((List<User> list){


setState((){
  userList= list;
});
      
    
    });
  });
  }


searchAppBar(BuildContext context){
return GradientAppBar(
  gradient: LinearGradient(colors: [UniversalVariables.gradientColorStart,
  UniversalVariables.gradientColorEnd],),

leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), 
onPressed: ()=>Navigator.pop(context)),
elevation: 0,
bottom: PreferredSize(child: Padding(padding: EdgeInsets.only(left:20),child: TextField(
  controller:searchController,
  onChanged: (val){
    setState(() {
      query=val;
    }
    );
  },
  cursorColor: UniversalVariables.blackColor,
  autofocus: true,
  style: TextStyle(
    fontWeight:FontWeight.bold,
    color:Colors.white,
    fontSize:35,

  ),
  decoration: InputDecoration(
    suffixIcon:IconButton(icon: Icon(Icons.close,color:Colors.white),onPressed: (){
    WidgetsBinding.instance.addPostFrameCallback( (_) =>searchController.clear());
    },)
    ,border: InputBorder.none,
    hintText: "Search",
    hintStyle: TextStyle(    fontWeight:FontWeight.bold,
    color:Colors.white,
    fontSize:35,)
  ),
),), preferredSize: const Size.fromHeight(kToolbarHeight+20),),


);

}
  buildSuggestions(String query) {
  final List<User> suggestionList = query.isEmpty?[]:userList!=null?
  userList.where((User user) {


String _getUsername=user.username.toLowerCase();
String _query=query.toLowerCase();
String _getName=user.name.toLowerCase();
bool matchedUserName= _getUsername.contains(_query);
bool matchedName= _getName.contains(_query);
return (matchedUserName|| matchedName);



  }).toList():[];

return ListView.builder(itemCount:suggestionList.length,itemBuilder: ((context ,index){
User searchedUser= User(uid: suggestionList[index].uid,
profilePhoto: suggestionList[index].profilePhoto,
name:suggestionList[index].name,
username:suggestionList[index].username,
);

return CustomTile(
mini: false,
onTap:(){
Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiver:searchedUser)));
},
leading:CircleAvatar(
  backgroundImage:NetworkImage(searchedUser.profilePhoto),
  backgroundColor: Colors.grey,

),
title: Text(searchedUser.username,style:TextStyle(
  color:Colors.white,
  fontWeight:FontWeight.bold
)),
subtitle: Text(searchedUser.name,style:TextStyle(
  color:UniversalVariables.greyColor,
)), 
);

}));

}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:UniversalVariables.blackColor,
 appBar: searchAppBar(context), 
 body:Container( padding:EdgeInsets.symmetric(horizontal:20) ,
 child:buildSuggestions(query)
  )   
     );
   }

}