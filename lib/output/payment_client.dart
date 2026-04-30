import 'package:intl/intl.dart';
import 'package:lkmobileapp/entity/contract.dart';
import 'package:lkmobileapp/entity/payment.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/rest_client.dart';

class PaymentClient {
  Future<List<Payment>> getPaymentList(
      Contract contract, DateTime dateFrom, DateTime dateTo) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDateFrom = formatter.format(dateFrom);
    final String formattedDateTo = formatter.format(dateTo);
    var jsonMap = await RestClient.getInstance().get(
        contract.title,
        Uri.parse(
            "${LkPreferences.hostProxy}/request/getPaymentList?dateFrom=$formattedDateFrom&dateTo=$formattedDateTo"));
    return List<Payment>.from(jsonMap.map((value) => Payment.fromJson(value)));
  }

  Future<String> getPaymentUrl(Contract contract, int amount) async {
    String url =
        "${LkPreferences.sbpQrPaymentServiceUrl}/createOrder/${contract.title}/$amount";
    var jsonMap =
        await RestClient.getInstance().get(contract.title, Uri.parse(url));
    return jsonMap["url"].toString();
  }
}
