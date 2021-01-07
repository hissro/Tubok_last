import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/global.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mnasbti_admin/Login/utils/network_util.dart';
import 'package:mnasbti_admin/utilits/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config.dart';

class LoginPage extends StatefulWidget
{
  LoginPage({Key key}) : super(key: key);
  static const String routeName = "login";
  @override
  _LoginPageState createState() => new _LoginPageState();
}




class _LoginPageState extends State<LoginPage>  with SingleTickerProviderStateMixin
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  NetworkUtil _netUtil = new NetworkUtil();




  @override
  Widget build(BuildContext context)
  {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    //changeLocale(context, 'ar');

    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: new BoxDecoration(
//              gradient: new LinearGradient(
//                  colors: [
//                    GetColor.hexToColor("FFC0CB"),
//                    GetColor.hexToColor("B25162"),
////                    Theme.Colors.loginGradientStart,
////                    Theme.Colors.loginGradientEnd
//                  ],
//                  begin: const FractionalOffset(0.0, 0.0),
//                  end: const FractionalOffset(1.0, 1.0),
//                  stops: [0.0, 1.0],
//                  tileMode: TileMode.clamp),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: //Text(translate('app_bar.app_name'),style: TextStyle(fontFamily: 'Bin' , fontSize: 20.0, fontWeight: FontWeight.w900 , color: Colors.white), ),

                      Image(
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.fill,
                          image: new AssetImage('assets/images/logo.png')),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),
//                          new ConstrainedBox(
//                            constraints: const BoxConstraints.expand(),
//                            child: _buildSignUp(context),
//                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _pageController = PageController();
  }

  void showError(String value) {
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
      backgroundColor: Colors.deepOrangeAccent,
      duration: Duration(seconds: 3),
    ));
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
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container();

    /*  return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    ); */
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.mobile,
                              color: Colors.teal,
                              size: 22.0,
                            ),
                            hintText: translate('app.email'),
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.teal,
                            ),
                            hintText: translate('app.password'),
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: GetColor.hexToColor("FFC0CB"),
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: GetColor.hexToColor("16a085"),
                      offset: Offset(1.0, 6.0),
                      blurRadius: 1.0,
                    ),
                  ],
//                  gradient: new LinearGradient(
//                      colors: [
//                        GetColor.hexToColor("8C2A3C"),
//                        GetColor.hexToColor("8C2A3C"),
//
//                        //Theme.Colors.loginGradientEnd,
//                        //Theme.Colors.loginGradientStart
//                      ],
//                      begin: const FractionalOffset(0.2, 0.2),
//                      end: const FractionalOffset(1.0, 1.0),
//                      stops: [0.0, 1.0],
//                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.teal,
//                    splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        translate('app.Login'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "Title"),
                      ),
                    ),
                    onPressed: Login_api),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {
                  var email = loginEmailController.text;
                  if (email.length <= 0 ) {
                    showError('phone is null');
                  } else {
                    _revoveryPassword(email);
                  }
                },
                child: Text(
                  translate('app.ForgotPassword'),
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey,
                      fontSize: 16.0,
                      fontFamily: "Title"),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
//                    gradient: new LinearGradient(
//                        colors: [
//                          Colors.white10,
//                          Colors.white,
//                        ],
//                        begin: const FractionalOffset(0.0, 0.0),
//                        end: const FractionalOffset(1.0, 1.0),
//                        stops: [0.0, 1.0],
//                        tileMode: TileMode.clamp),
                      ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "2020",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
//                Container(
//                  decoration: BoxDecoration(
//                    gradient: new LinearGradient(
//                        colors: [
//                          Colors.white,
//                          Colors.white10,
//                        ],
//                        begin: const FractionalOffset(0.0, 0.0),
//                        end: const FractionalOffset(1.0, 1.0),
//                        stops: [0.0, 1.0],
//                        tileMode: TileMode.clamp),
//                  ),
//                  width: 100.0,
//                  height: 1.0,
//                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _revoveryPassword(String email) async {
    NetworkUtil _netUtil = new NetworkUtil();
    return _netUtil.post(Config.RecoveryPassword,
        body: {"user_email": email}).then((dynamic res) {
      print(res);
      if (res["responce"] == true) {
        showInSnackBar(res["error"]);
      } else {
        showError(res["error"]);
      }
    });
  }

  void Login_api() {

    var email = loginEmailController.text;
    var password = loginPasswordController.text;

    login(email, password);
  }

  Future<Null> login(String email, String password) async
  {

    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") != null ? prefs.getString("token") : "";


    if (email.length <= 0 )
      {
        showError( translate("app.phone_null")  );
      }
    else if (password.length <= 0 )
      {
        showError(translate("app.password_null") );
      }
    else
      {
        _netUtil.post("https://apps.hissro.net/tabukProject/api/login",
            body: {
              "phone": email,
              "password": password,
              "token": token
            }).then((dynamic res)
        {
          if (res["responce"] == true) {
            StorageUtil.saveLogin(res["data"]);

            showInSnackBar(translate("app.welcomemessage"));
            Timer(const Duration(milliseconds: 3000), () {
              setState(() {
                Navigator.of(context).pushReplacementNamed("Home");
              });
            });
          } else {
            showError(res["error"]);
          }
        });
      }


  }



  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
