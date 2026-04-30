import 'dart:io';

class PostHttpOverrides extends HttpOverrides {
  //Нужно чтоб игнорировать ssl
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
