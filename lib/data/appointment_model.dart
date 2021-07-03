import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;

class AppointmentData {
  late String storeID,
      customerID,
      serviceID,
      slot,
      stylist;

  late DateTime date;
}

class AppointmentModel {

  static Future<int> postData(AppointmentData data) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://salonneeds.in/gaurav/api/appointment_api.php'));
    request.fields.addAll({
      'store_id': data.storeID,
      'service_id': data.serviceID,
      'date': formatDate(data.date, [yyyy, '-', mm, '-', dd]),
      'slot': data.slot,
      'stylist': data.stylist,
      'customer_id': data.customerID
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return 200;
    } else {
      print(response.reasonPhrase);
      return 0;
    }
  }
}
