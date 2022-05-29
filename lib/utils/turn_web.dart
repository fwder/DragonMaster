import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<Map> getTurnCredential(String host, int port) async {
  var url = 'https://$host:$port/api/turn?service=turn&username=flutter-webrtc';
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    if (kDebugMode) {
      print('getTurnCredential:response => $data.');
    }
    return data;
  }
  return {};
}
