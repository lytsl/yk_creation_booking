import 'dart:convert';

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

  static Future<dynamic> postData(AppointmentData data) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://salonneeds.in/gaurav/api/appointment_api.php'));
    request.fields.addAll({
      'store_id': data.storeID,
      'service_id': data.serviceID,
      'date': formatDate(data.date, [yyyy, '-', mm, '-', dd]),
      'slot': data.slot,
      'stylist': data.stylist,
      'customer_id': data.customerID
    });
    print(request.fields.toString());
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print(responseString);
      final responseData = jsonDecode(responseString);
      if(responseData['status'] == true)
        return 200;
      String msg = responseData['msg'];
      if(msg=='You are can not Book Appointment this slot'){
        return 'You cannot book appointment for this slot. Available Slot: ' +responseData['data']['available_slot'];
      }
      return msg;
    } else {
      print(response.reasonPhrase);
    }
  }
}
