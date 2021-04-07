import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skype/Screens/callscreens/call_screen.dart';
import 'package:skype/Screens/chat_screen_widgets/cached_image.dart';
import 'package:skype/models/call.dart';
import 'package:skype/resourses/call_methods.dart';
import 'package:skype/utils/permission.dart';

class Pickup_Screen extends StatelessWidget {

final Call call;
final CallMethods callMethods=CallMethods();

   Pickup_Screen({@required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical:100),
        child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children:<Widget>[
            Text("incoming...",style: TextStyle(fontSize:30),),
            SizedBox(height: 50,),
            Cachedimage(call.callerPic,isRound: true,radius:180),
          SizedBox(height:15),
          Text(call.callerName,style:TextStyle(fontWeight:FontWeight.bold,fontSize:20) ,)
          ,SizedBox(height:75),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              IconButton(icon: Icon(Icons.call_end),color:Colors.redAccent, onPressed:()async{
                await callMethods.endCall(call:call);
              }),
              SizedBox(width:25),
              IconButton(icon: Icon(Icons.call),color:Colors.green,onPressed: ()async=>await
                   Permissions.cameraAndMicrophonePermissionsGranted()? 
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>CallScreen(call:call)
              )
              ):{},)
            ])
          ])
      ),
    );
  }
}