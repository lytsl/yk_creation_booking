
import 'package:http/http.dart' as http;

class Profile{
  String? customerID,name,gender,email;
}

class ProfileModel{

  static Future<void> postData(Profile profile) async {

    var request = http.MultipartRequest('POST', Uri.parse('http://salonneeds.in/gaurav/api/profile_api.php'));
    request.fields.addAll({
      'customer_id': profile.customerID!,
      'name': profile.name!,
      'gender': profile.gender!,
      'email': profile.email!,
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }

  }

}