import 'package:flutter_test/flutter_test.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/rest_client.dart';

void main(){
  test("getPaymentUrl", () async {

    String url =
        "${LkPreferences.sbpQrPaymentServiceUrl}/createOrder/89679333444/10";
    var jsonMap =
    await RestClient.getInstance().getNewClient('89679333444', '12345');
    dynamic res = await RestClient.getInstance().get('89679333444', Uri.parse(url));
    print(res.toString());
  });
}