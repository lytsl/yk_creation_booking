import 'dart:convert';

import 'package:http/http.dart' as http;

class SalonService {
  late String id, name, storeID;
  late int duration, price, tax;

  SalonService(
      {required this.storeID,
      required this.name,
      required this.id,
      required this.duration,
      required this.price,
      required this.tax});

  factory SalonService.fromJson(Map<String, dynamic> json) {
    return SalonService(
        storeID: json['stores_id'] ?? 'store id',
        name: json['service_name'] ?? 'service name',
        id: json['id'] ?? 'id',
        duration: int.tryParse(json['duration'] as String) ?? 0,
        price: int.tryParse(json['price'] as String) ?? 0,
        tax: int.tryParse(json['tax'] as String) ?? 0,
    );
  }
}

class SalonServiceModel{
  static Future<List<SalonService>> postData(String id) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://salonneeds.in/gaurav/api/service_list_api.php'));
    request.fields.addAll({
      'store_id': id
    });


    http.StreamedResponse response = await request.send();

    List<SalonService> salonList = [];

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print(responseString);
      final responseData = jsonDecode(responseString);
      final List<dynamic> serviceListData = responseData['data'];
      for(int i=0;i<serviceListData.length;i++){
        salonList.add(SalonService.fromJson(serviceListData[i]));
      }

    }
    else {
      print(response.reasonPhrase);
    }

    return salonList;
  }
}
