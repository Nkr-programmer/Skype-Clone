import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:skype/Screens/pickup/pickup_screen.dart';
import 'package:skype/models/call.dart';
import 'package:skype/provider/user_provider.dart';
import 'package:skype/resourses/call_methods.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods= CallMethods();

   PickupLayout({@required this.scaffold});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider= Provider.of<UserProvider>(context);
    return (userProvider!= null && userProvider.getUser!=null)?
    StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid:userProvider.getUser.uid),
      builder:(context,snapshot){
        if(snapshot.hasData&&snapshot.data.data!=null){
         Call call= Call.fromMap(snapshot.data.data);

if(!call.hasDialled){
  return Pickup_Screen(call: call);
}


  return scaffold;
        }
        return scaffold;
      },
    ):Scaffold(body:Center(
      child:CircularProgressIndicator(),
    ));
  }
}