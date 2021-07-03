import 'dart:convert';

import 'package:http/http.dart' as http;

class SalonLocation{

  late String storeName,storeAddress,storeID;

  SalonLocation({required this.storeAddress,required this.storeName,required this.storeID});

  factory SalonLocation.fromJson(Map<String, dynamic> json){
    print(json['id']);
    return SalonLocation(storeAddress: json['address'], storeName: json['store_name'],storeID: json['id']);
  }
}

class SalonLocationModel{
  static const url = 'http://salonneeds.in/gaurav/api/appointment_api.php';

  static String? customerID;

  static Future<List<SalonLocation>> getLocationList(String number) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://salonneeds.in/gaurav/api/login.php'));
    request.fields.addAll({
      'contact_number': number.substring(1)
    });

    http.StreamedResponse response = await request.send();

    List<SalonLocation> salonLocationList = [];

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print(responseString);
      final responseData = jsonDecode(responseString);
      customerID = responseData['data']['customer_id'];
      final List<dynamic> storeListData = responseData['data']['store'];
      for(int i=0;i<storeListData.length;i++){
        salonLocationList.add(SalonLocation.fromJson(storeListData[i]));
      }
    }
    else {
      print(response.reasonPhrase);
    }

    return salonLocationList;
  }

  static Future<bool> isNewCustomer(String number) async{
    var request = http.MultipartRequest('POST', Uri.parse('http://salonneeds.in/gaurav/api/login.php'));
    request.fields.addAll({
      'contact_number': number.substring(1)
    });

    http.StreamedResponse response = await request.send();

    bool isNewCust = true;

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print(responseString);
      final responseData = jsonDecode(responseString);
      isNewCust = responseData['data']['is_new_customer'] ?? true;
      customerID = responseData['data']['customer_id'];
    }
    else {
      print(response.reasonPhrase);
    }

    return isNewCust;
  }

  static Future<String?> getCustomerID(String number) async{
    var request = http.MultipartRequest('POST', Uri.parse('http://salonneeds.in/gaurav/api/login.php'));
    request.fields.addAll({
      'contact_number': number.substring(1)
    });

    http.StreamedResponse response = await request.send();

    String? customer_id;

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print(responseString);
      final responseData = jsonDecode(responseString);
      customer_id = responseData['data']['customer_id'];
    }
    else {
      print(response.reasonPhrase);
    }

    return customer_id;
  }

}