import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:mnasbti_admin/Home/Home.dart';
import 'package:mnasbti_admin/utilits/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Config.dart';
import 'Home/NewOrder.dart';
import 'Login/utils/network_util.dart';
import 'package:share/share.dart';
import 'Profile/UserProfile.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer>
{
  NetworkUtil _netUtil = new NetworkUtil();

  var user_id ;
  var user_name ;
  var phone ;
  var image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIqtC7K9hXXGa821c0OkwppyASRCjHj_Pubh9ScF5v9XVC8acGhQ&s";

  void initState() {
    super.initState();
    LoadStiatic();
  }

  Future LoadStiatic() async
  {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      user_name = prefs.getString("user_name");
      phone = prefs.getString("phone");
      image = prefs.getString("image");
      user_id = prefs.getString("user_id");
    });



  }

  void update() {
    setState(()
    {
    });
  }

  @override
  Widget build(BuildContext context)
  {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text("  $phone " ), //home_info.bus_email
            accountName: Text(" $user_name " ,style: TextStyle(fontFamily: 'noura')), //home_info.bus_title
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(image),
              backgroundColor: Colors.transparent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home  ,color: Colors.teal),
            title: Text(translate('app.home') ,style: TextStyle(fontFamily: 'noura'),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add_to_photos , color: Colors.teal ,),
            title: Text(translate('app.statistic') ,style: TextStyle(fontFamily: 'noura')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewOrder()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle ,color: Colors.teal ),
            title: Text(translate('app.profile') ,style: TextStyle(fontFamily: 'noura') ),
            onTap: () {
              Navigator.pushNamed(context, Profile.routeName);
            },
          ),

          ListTile(
            leading: Icon(Icons.language  ,color: Colors.teal),
            title: Text(translate('app.language') ,style: TextStyle(fontFamily: 'noura') ),
            onTap: () {
              _onActionSheetPress(context);
            },
          ),


          ListTile(
            leading: Icon(Icons.share  ,color: Colors.teal),
            title: Text(translate('app.share') ,style: TextStyle(fontFamily: 'noura')),
            onTap: () {
              Share.share(translate('app.shareTo') );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock  ,color: Colors.teal),
            title: Text(translate('app.logout') ,style: TextStyle(fontFamily: 'noura')),
            onTap: () {
              StorageUtil.Loginout();
              Navigator.of(context).pushReplacementNamed("login");
            },
          ),
        ],
      ),
    );

//    return FutureBuilder(
//      future: LoadStiatic(),
//      builder: (BuildContext context, AsyncSnapshot snap)
//      {
//        if (snap.hasData)
//        {
//          var bus_email = snap.data[0]["bus_email"];
//          var bus_title = snap.data[0]["bus_title"];
//          var bus_logo = Config.business_image + snap.data[0]["bus_logo"];
//
//          return Container();
//        } else {
//          return Container(
//            child: Center(
//              child: Text(translate('app.Loading')),
//            ),
//          );
//        }
//      },
//    );
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String value) {
      changeLocale(context, value);
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(
          translate('language.selection.title'),
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.name.ar')),
            onPressed: () => Navigator.pop(context, 'ar'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.en')),
            onPressed: () => Navigator.pop(context, 'en_US'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate('app.cancel')),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }
}
