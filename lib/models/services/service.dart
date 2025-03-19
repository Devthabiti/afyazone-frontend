import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './utls.dart';

//fetch User Details
fetchClientDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = Uri.parse('${Api.baseUrl}/view-client-profile/');

  var token = prefs.getString('token');
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
  var userId = decodedToken['user_id'];

  // Defined headers
  Map<String, String> headers = {
    //'Authorization': ' Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  var body = {
    "user_id": userId,
  };
  // Get request
  var response = await http.post(
    url,
    headers: headers,
    body: json.encode(body),
  );
  // Check the status code of the response
  if (response.statusCode == 200) {
    var iyoo = json.decode(utf8.decode(response.bodyBytes));
    return iyoo;
  } else {
    return null;
  }
}

//fetching list of doctors
fetchDoctors() async {
  var url = Uri.parse('${Api.baseUrl}/doctors/');
  // Defined headers
  Map<String, String> headers = {
    //'Authorization': ' Bearer $token',
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };
  // Get request
  var response = await http.get(
    url,
    headers: headers,
  );
  // Check the status code of the response
  if (response.statusCode == 200) {
    // var iyoo = json.decode(response.body);
    var iyoo = json.decode(utf8.decode(response.bodyBytes));
    return iyoo;
  } else {
    return null;
  }
}

//fetching my inbox
fetchInboxes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
  var userId = decodedToken['user_id'];

  var response = await http.get(
    Uri.parse('${Api.baseUrl}/my-messages/$userId/'),
  );

  if (response.statusCode == 200) {
    var iyoo = json.decode(utf8.decode(response.bodyBytes));
    return iyoo;
  } else {
    return null;
  }
}

//fetching 1 vs 1 chat
getChats(sId, rId) async {
  var response = await http.get(
    Uri.parse('${Api.baseUrl}/get-messages/$sId/$rId/'),
  );
  if (response.statusCode == 200) {
    List iyoo = json.decode(utf8.decode(response.bodyBytes));
    return iyoo;
  } else {
    return null;
  }
}

//fetching articles and story
getnews() async {
  var response = await http.get(
    Uri.parse('${Api.baseUrl}/show-article/'),
  );
  if (response.statusCode == 200) {
    Map data = json.decode(utf8.decode(response.bodyBytes));
    List iyoo = data['results'];
    return iyoo;
  } else {
    return null;
  }
}

//fetching articles and story
gettransaction() async {
  var response = await http.get(
    Uri.parse('${Api.baseUrl}/show-transaction/'),
  );
  if (response.statusCode == 200) {
    List iyoo = json.decode(response.body);
    return iyoo;
  } else {
    return null;
  }
}

//fetching 1 vs 1 chat
fetchvievs(postId) async {
  var response = await http
      .post(Uri.parse('${Api.baseUrl}/views/'), body: {"post_id": postId});
  if (response.statusCode == 200) {
    var iyoo = json.decode(response.body);
    return iyoo;
  } else {
    return null;
  }
}

//fetching all ads
getads() async {
  var response = await http.get(
    Uri.parse('${Api.baseUrl}/ads/'),
  );
  if (response.statusCode == 200) {
    List iyoo = json.decode(response.body);

    return iyoo;
  } else {
    return null;
  }
}
