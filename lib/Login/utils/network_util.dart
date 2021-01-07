import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetworkUtil
{
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url)
  {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {body, encoding}) {
    return http
        .post(url,
        body: body,
        headers: {},
        encoding: encoding)
        .then((http.Response response)
    {
      final String res = response.body;
      final int statusCode = response.statusCode;

//      debugPrint (res);
      //print( res.toString() );
      if (statusCode < 200 || statusCode > 400 || json == null)
      {
        debugPrint (res);
        throw new Exception("Error while fetching data");
      } else

        return _decoder.convert(res);
    });
  }


//
//  Future<dynamic> post(String url, {body, encoding}) {
//    return http
//        .post(url,
//            body: body,
//            headers: {"Token": 'PBCVkeBnstoCf69wjJgySiGg5cCwCmK'},
//            encoding: encoding)
//        .then((http.Response response)
//    {
//      final String res = response.body;
//      final int statusCode = response.statusCode;
//
//      debugPrint (res);
//      //print( res.toString() );
//      if (statusCode < 200 || statusCode > 400 || json == null)
//      {
//        debugPrint (res);
//        throw new Exception("Error while fetching data");
//      } else
//
//        return _decoder.convert(res);
//    });
//  }
}


class GetColor {

  static Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}