import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('payment generate url test', () async {
    var body = {'userLoginBilling': "89003222222", 'paySum': 1.toString()};
    var response = await http.post(Uri.parse("https://fly-tech.ru/soapCP.php"),
        body: body);
    final locationHeader = response.headers['location'];
    debugPrint(locationHeader);
  });
}

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
