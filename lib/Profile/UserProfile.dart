import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mnasbti_admin/Home/Home.dart';
import 'package:mnasbti_admin/Login/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Config.dart';
import '../Drawer.dart';

class Profile extends StatefulWidget {
  static const String routeName = "Profile";

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile>
{
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = false ;

  Future LoadStiatic() async {
    var prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("user_id");

    return _netUtil.post("https://apps.hissro.net/tabukProject/api/Userinfo", body: {
      "user_id": user_id,
    }).then((dynamic res) {
      return res["data"];
    });
  }

  TextEditingController emailContrller = TextEditingController();
  TextEditingController passwordContrller = TextEditingController();
  TextEditingController user_fullnameContrller = TextEditingController();
  TextEditingController user_phoneContrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(translate('app.profile') ,style: TextStyle(fontFamily: 'Bin'),),
      ),
      body: new FutureBuilder(
        future: LoadStiatic(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData)
          {
            var user_email = snap.data[0]["phone"];
            var user_fullname = snap.data[0]["user_name"];
            var user_phone = snap.data[0]["phone"];

            var bus_logo =  Config.ImagePath +snap.data[0]["image"];

            user_fullnameContrller.text = user_fullname;
            emailContrller.text = user_email;
            user_phoneContrller.text = user_phone;

            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: Image.network(bus_logo),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextField(
                        autofocus: false,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        controller: user_fullnameContrller,
                        decoration: InputDecoration(
                            labelText: translate('app.user_fullname'),
                            hintText: user_fullname,
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.green,
                                    style: BorderStyle.solid))),
                      ),


                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        autofocus: false,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: user_phoneContrller,
                        decoration: InputDecoration(
                            labelText: translate('app.user_phone'),
                            hintText: user_phone,
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.teal,
                                    style: BorderStyle.solid))),
                      ),

//                      SizedBox(
//                        height: 30,
//                      ),
//                      TextField(
//                        autofocus: false,
//                        obscureText: false,
//                        keyboardType: TextInputType.emailAddress,
//                        controller: emailContrller,
//                        decoration: InputDecoration(
//                            labelText: translate('app.user_email'),
//                            hintText: user_email,
//                            labelStyle: TextStyle(
//                              color: Colors.black,
//                              fontSize: 16,
//                            ),
//                            border: OutlineInputBorder(
//                                borderRadius:
//                                    BorderRadius.all(Radius.circular(4)),
//                                borderSide: BorderSide(
//                                    width: 1,
//                                    color: Colors.teal,
//                                    style: BorderStyle.solid))),
//                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        autofocus: false,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        controller: passwordContrller,
                        decoration: InputDecoration(
                            labelText: translate('app.user_password'),
                            hintText: translate('app.user_password'),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.teal,
                                    style: BorderStyle.solid))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _loading == true? Loading(indicator: BallPulseIndicator(), size: 40.0, color: Colors.teal) : Container(),

                      SizedBox(
                        height: 50,
                      ),
                      ButtonTheme(
                        //elevation: 4,
                        //color: Colors.green,
                        minWidth: double.infinity,
                        child: MaterialButton(
                          onPressed: ()
                          {
                            _update_profile();
                          },
                          textColor: Colors.white,
                          color: Colors.teal,
                          height: 50,
                          child: Text(translate('app.update')),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: Text(translate('app.Loading')),
              ),
            );
          }
        },
      ),
      drawer: MainDrawer(),

    );
  }


  void _update_profile() async
  {
    setState(() {
      _loading = true;
    });
    var prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("user_id");
//    var user_email = emailContrller.text;
    var user_password = passwordContrller.text;
    var user_name = user_fullnameContrller.text;
    var phone = user_phoneContrller.text;

    return _netUtil.post('https://apps.hissro.net/tabukProject/api/UpdateUser', body: {
      "user_id": user_id,
      "user_password":user_password,
      "user_name":user_name,
      "phone":phone
    }).then((dynamic res)
    async {
      setState(() {
        _loading = false;
      });
      if (res["responce"] == true)
      {
        _showmsg(translate('app.updated'));
        await prefs.setString("user_name", user_name );
        await prefs.setString("phone", phone );
        Timer(Duration(seconds: 3), ()
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
        });


      } else
        {
          _showmsg(res["data"]["error"]);
      }
    });
  }

  void _showmsg (String value)
  {


      FocusScope.of(context).requestFocus(new FocusNode());
      _scaffoldKey.currentState?.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: "WorkSansSemiBold"),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      ));


//    Fluttertoast.showToast(
//        msg: msg,
//        toastLength: Toast.LENGTH_LONG,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIos: 1,
//        backgroundColor: Colors.green,
//        textColor: Colors.white,
//        fontSize: 16.0
//    );

  }


}








