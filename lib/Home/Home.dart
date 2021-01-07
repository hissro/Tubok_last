import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:mnasbti_admin/Card/themes.dart';
import 'package:mnasbti_admin/Login/utils/network_util.dart';
import 'package:mnasbti_admin/Model/MyOrder.dart';
import 'package:mnasbti_admin/utilits/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Drawer.dart';

class Home extends StatefulWidget {
  static const String routeName = "Home";
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  NetworkUtil _netUtil = new NetworkUtil();
  var user_info;
  var home_info;
  var bus_title = "";
  var bus_email = "";
  var bus_logo = "";

  @override
  Future<void> initState() {
    super.initState();
    this.CeakLogin();
  }

  void CeakLogin() async {
    StorageUtil.getLoginInfo().then((dynamic userinfo) {
      user_info = userinfo;
    });
    var prefs = await SharedPreferences.getInstance();
  }

  Future<List<Myorder>> LoadOrder() async {
    List<Myorder> _ordrs = [];
    var prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("user_id");

    return _netUtil.post("https://apps.hissro.net/tabukProject/api/requests",
        body: {"user_id": user_id}).then((dynamic res) {
      var jsondata = res["data"];
      for (var i in jsondata) {
        Myorder my = Myorder(
            i["requests_id"],
            i["user_id"],
            i["title"],
            i["description"],
            i["status"],
            "https://apps.hissro.net/tabukProject/uploads/logo.jpg");
        _ordrs.add(my);
      }
      return _ordrs;
    });
  }

  Future<List<Widget>> Serve_list(List<Widget> vv) async {
    return vv;
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            translate('app_bar.app_name'),
            style: TextStyle(fontFamily: 'Bin'),
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: LoadOrder(),
            builder: (BuildContext context, AsyncSnapshot snap) {
              if (snap.data == null) {
                if (snap.connectionState == ConnectionState.done) {
                  return Container(
                    child: Center(
                      child: Text(
                        translate('app.NoData'),
                        style: TextStyle(fontFamily: 'Bin'),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text(
                        translate('app.Loading'),
                        style: TextStyle(fontFamily: 'Bin'),
                      ),
                    ),
                  );
                }
              } else {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Material(
                        elevation: 4.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0,
                                      bottom: 0.0,
                                      left: 16.0,
                                      right: 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snap.data[index].title,
                                            style: boldBlackLargeTextStyle,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      ClipOval(
                                        child: Image.network(
                                          snap.data[index].image,
                                          fit: BoxFit.cover,
                                          height: 90.0,
                                          width: 90.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    snap.data[index].description,
                                    style: boldPurpleTextStyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 0.0,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snap.data.length,
                );
              }
            },
          ),
        ),
        drawer: MainDrawer());
  }
}
