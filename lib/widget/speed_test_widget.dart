import 'package:flutter/material.dart';
import 'package:lkmobileapp/mobile_lib.dart' if (dart.library.html) 'package:lkmobileapp/web_lib.dart';

class SpeedTest extends StatelessWidget {
  SpeedTest({super.key});
  final Uri _url = Uri.parse("https://www.speedtest.net/");

  @override
  Widget build(BuildContext context) {
    return webWidget(_url);
  }
}
