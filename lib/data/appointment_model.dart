import 'package:http/http.dart';

class AppointmentData {
  late String storeID,
      gender,
      serviceID = '?',
      date,
      slot,
      stylist,
      contactNumber,
      name = 'empty',
      email = 'empty',
      source = 'empty';
}

class AppointmentModel {
  static const url = 'http://salonneeds.in/gaurav/api/appointment_api.php';

  Future<dynamic> postData(AppointmentData data) async {
    var request = MultipartRequest('POST',
        Uri.parse('http://salonneeds.in/gaurav/api/appointment_api.php'));
    request.fields.addAll({
      'store_id': '1',
      'gender': '1',
      'service_id': '2',
      'date': '2021-06-23',
      'slot': '9:30',
      'stylist': '1',
      'contact_number': '1234567899',
      'name': 'demo demo',
      'email': 'demo@gmail.com',
      'source': 'advertisement'
    });

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
