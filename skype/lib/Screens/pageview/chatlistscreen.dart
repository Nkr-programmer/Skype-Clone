import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:skype/Screens/pageview/newchat_button.dart';
import 'package:skype/Screens/pageview/widgets/contact_view.dart';
import 'package:skype/Screens/pageview/widgets/quiet_box.dart';
import 'package:skype/Screens/pageview/widgets/user_circle.dart';
import 'package:skype/models/contact.dart';
import 'package:skype/provider/user_provider.dart';

import 'package:skype/resourses/Storage_methods.dart';
import 'package:skype/resourses/Auth_methods.dart';
import 'package:skype/resourses/chat_methods.dart';
import 'package:skype/utils/universal_variables.dart';
import 'package:skype/utils/utilities.dart';
import 'package:skype/widgets/appbar.dart';
import 'package:skype/widgets/custom_tile.dart';

class ChatListScreen extends StatelessWidget {
CustomAppBar customAppBar(BuildContext context){
return CustomAppBar( leading: IconButton(icon: Icon(Icons.notifications,color:Colors.white,),
 onPressed: (){})
 ,title: UserCircle(),
 centerTitle: true, actions: <Widget>[
  IconButton(icon: Icon(Icons.search,color:Colors.white), onPressed: (){
    Navigator.pushNamed(context, "/search_screen");
  }),
    IconButton(icon: Icon(Icons.more_vert,color:Colors.white), onPressed: (){})

],);

}


@override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body:ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
final ChatMethods _chatMethods= ChatMethods(); 
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider= Provider.of<UserProvider>(context);
    return Container(
 child: 
 StreamBuilder<QuerySnapshot>(
   stream: _chatMethods.fetchContacts(userId:userProvider.getUser.uid),
   builder: (context, snapshot) {
     if(snapshot.hasData){
       var docList = snapshot.data.documents;

       if(docList.isEmpty){
         return QuietBox();
       }
     
     return ListView.builder(padding:EdgeInsets.all(10),
     itemCount: docList.length,
     itemBuilder: (context,index){
       Contact contact = Contact.fromMap(docList[index].data);
       return Contact_view(contact);
            },
          );
     }

return Center(child: CircularProgressIndicator());

   }
 ),
    );
  }
}
