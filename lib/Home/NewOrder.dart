import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mnasbti_admin/Login/utils/network_util.dart';
import '../Config.dart';
import '../Drawer.dart';
import 'Home.dart';


class NewOrder extends StatefulWidget
{
  @override
  _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder>
{

  final titlec = TextEditingController();
  final descriptionc = TextEditingController();
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _loading = false ;

  @override
  void initState() {
    super.initState();
  }

  void showInSnackBar(String value)
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
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
    });



  }
  void showInSnackBarerror(String value)
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
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(translate("app.statistic" ) ,style: TextStyle(fontFamily: 'Bin'),),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.teal,
                      Colors.blueGrey
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(90)
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.add_to_home_screen,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),

//                  Align(
//                    alignment: Alignment.bottomRight,
//                    child: Padding(
//                      padding: const EdgeInsets.only(
//                          bottom: 32,
//                          right: 32
//                      ),
//                      child: Text('Login',
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 18
//                        ),
//                      ),
//                    ),
//                  ),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 62),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    padding: EdgeInsets.only(
                        top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50)
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 56
                          )
                        ]
                    ),
                    child: TextField(
                      controller: titlec,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.message,
                          color: Colors.teal,
                        ),
//                        hintText: 'Title',
                        hintText: translate("app.title" ),
                        hintStyle: TextStyle(fontFamily: 'Bin'),
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.only(
                        top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50)
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: TextField(
                      controller: descriptionc,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.description,
                          color: Colors.teal,
                        ),
                        hintText: translate("app.description" ),
                        hintStyle: TextStyle(fontFamily: 'Bin' , ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  _loading == true? Loading(indicator: BallPulseIndicator(), size: 40.0, color: Colors.teal) : Container(),


                  Spacer(),

                  InkWell(
                    onTap: ()
                    {

                      print(  ' login ${titlec.text} ');

                      setState(() {
                        _loading = true;
                      });
                      var title = titlec.text ;
                      var description = descriptionc.text ;

                      _netUtil.post(Config.add_request, body: {
                        "title": title,
                        "description": description
                      }).then((dynamic res)
                      {
                        setState(() {
                          _loading = false;
                        });

                        print(res);
                        var responce = res["responce"];
                        var userdata = res["data"];
                        if (responce == true )
                        {
                          showInSnackBar (translate ("app.sess") + ' ${userdata["rowno"]} ');
                        }
                        else
                        {
                          showInSnackBarerror( translate ("error_sending"));
                        }
                      });


                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width/1.2,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                             colors: [
                               Colors.teal,
                              Color(0xFF00abff),
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(50)
                          )
                      ),
                      child: Center(
                        child: Text( translate('app.send'),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),

          ],

        ),
      ),
    );
  }
}
