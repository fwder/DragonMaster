import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

Future<Map> getTurnCredential(String host, int port) async {
    HttpClient client = HttpClient(context: SecurityContext());
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      if (kDebugMode) {
        print('getTurnCredential: Allow self-signed certificate => $host:$port. ');
      }
      return true;
    };
    var url = 'https://$host:$port/api/turn?service=turn&username=flutter-webrtc';
    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();
    var responseBody = await response.transform(const Utf8Decoder()).join();
    if (kDebugMode) {
      print('getTurnCredential:response => $responseBody.');
    }
    Map data = const JsonDecoder().convert(responseBody);
    return data;
  }
