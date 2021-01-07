import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mnasbti_admin/utilits/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'Config.dart';
import 'Home/Home.dart';
import 'Home/NewOrder.dart';
import 'Login/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Login/utils/TranslatePreferences.dart';
import 'Login/utils/network_util.dart';
import 'MyNotification/Notifaction.dart';
import 'Profile/UserProfile.dart';




void main() async {
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'ar',
      preferences: TranslatePreferences(),
      supportedLocales: ['ar', 'en_US', 'es', 'fa']);
  runApp(LocalizedApp(delegate, MyAppp()));
}

class MyAppp extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      "login": (BuildContext context) => new LoginPage(),
      Home.routeName: (BuildContext context) => new Home(),
      'dashbord':(BuildContext context) => new NewOrder(),
      'LocalNotificationWidget': (BuildContext context) => new  LocalNotificationWidget(),
      Profile.routeName: (BuildContext context) => new  Profile(),
    };
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'خدماتي',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(primarySwatch: Colors.teal),
        debugShowCheckedModeBanner: false,
        home: MyApp(),
        routes: routes,
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  var isLogin = false;
  var Nexpage;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NetworkUtil _netUtil = new NetworkUtil();

  @override
  void initState() {
    super.initState();
    CeakLogin();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message)
      {
        showNotification (message);

        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        showNotification (message);
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        showNotification (message);
        print('on launch $message');
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
//       print(' Setting Regstration $setting');
    });

    _firebaseMessaging.getToken().then((token) {
      StorageUtil.saveToken(token);
      updatefcm(token);
      //print("getToken:: " + token);
    });

    Stream<String> fcmStream = _firebaseMessaging.onTokenRefresh;
    fcmStream.listen((token) {
      StorageUtil.saveToken(token);
      print('New Token:: $token');
      updatefcm(token);
    });

    /****************** FCM *********************/
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    startTime();



  }


  /****************** FCM *********************/
  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }


  showNotification(message) async
  {
    print('show '+message['notification']["title"]);
    var title = message['notification']["title"] ;
    var body = message['notification']["body"] ;
    var android = new AndroidNotificationDetails(  'channel id', 'channel NAME', 'CHANNEL DESCRIPTION', priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(  0, title, body, platform,  payload: 'Hissro');
  }

  /****************** FCM *********************/

  updatefcm(String fcmtoken) async
  {
    var prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("user_id") ?? null;
    if (user_id != null )
    {
      return _netUtil.post("https://apps.hissro.net/tabukProject/api/updatefcm",
          body: {"user_id": user_id, "token": fcmtoken}).then((dynamic res)
      {
        if (res["responce"] == true)
        {
        //  print('update FCM ok');
        } else
          {
          //print('update FCM error {' + res["error"] + '}');
        }
      });
    }
     
  }

  startTime() async
  {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(Nexpage);
  }



  void CeakLogin() async {
    StorageUtil.getLogin().then((dynamic res) {
      setState(() {
        isLogin = res;
        if (isLogin == true)
        {
//          LoadStiatic();
          Nexpage = "Home";
        //  Nexpage = "LocalNotificationWidget";
        } else
          Nexpage = "login";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('assets/images/logo.png',width: 10, height: 80,),
          SizedBox(height: 300,),
          SpinKitPulse(
            color: Colors.teal,
            size: 100.0,
          )
        ],
      ),
    );
  }
}
