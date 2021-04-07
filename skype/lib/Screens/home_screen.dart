import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype/Screens/pickup/pickup_layout.dart';
import 'package:skype/enum/user_state.dart';
import 'package:skype/provider/user_provider.dart';
import 'package:skype/resourses/Auth_methods.dart';
import 'package:skype/utils/universal_variables.dart';
import 'pageview/chatlistscreen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  PageController pageController;
  int _page = 0;
  final AuthMethods _authMethods= AuthMethods();
 UserProvider userProvider;
  @override
  void initState() {
    super.initState();
   
    SchedulerBinding.instance.addPostFrameCallback((_)async {
       userProvider=Provider.of<UserProvider>(context,listen:false);
   await  userProvider.refreshUser();

    _authMethods.setUserState(userId: userProvider.getUser.uid, userState: UserState.OnliNE);
    });
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

@override
void  dispose()
{
  super.dispose();
  WidgetsBinding.instance.removeObserver(this);
}
@override 
void didChangedAppLifeCycle(AppLifecycleState state){
  String currentUserId= 
  (userProvider !=null && userProvider !=null)?userProvider.getUser.uid:"";
  super.didChangeAppLifecycleState(state);
  switch(state){
    
    case AppLifecycleState.resumed:
      // TODO: Handle this case.
       currentUserId!=null?  _authMethods.setUserState(userId: currentUserId,userState: UserState.OnliNE):print("resume");
      break;
    case AppLifecycleState.inactive:
      // TODO: Handle this case.
            currentUserId!=null?  _authMethods.setUserState(userId: currentUserId,userState: UserState.Offline):print("offline");
      break;
    case AppLifecycleState.paused:
       currentUserId!=null?  _authMethods.setUserState(userId: currentUserId,userState: UserState.Waiting):print("Paused");

      // TODO: Handle this case.
      break;
    case AppLifecycleState.detached:
           currentUserId!=null?  _authMethods.setUserState(userId: currentUserId,userState: UserState.Offline):print("detached");

      // TODO: Handle this case.
      break;
  }
}
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;

    return PickupLayout(
          scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(child:ChatListScreen()),
            Center(child: Text("Call Logs", style: TextStyle(color: Colors.white),)),
            Center(child: Text("Contact Screen", style: TextStyle(color: Colors.white),)),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      color: (_page == 0)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 0)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.call,
                      color: (_page == 1)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 1)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone,
                      color: (_page == 2)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 2)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}