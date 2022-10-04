import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiConnector {
  static Future<String> getCheckpoint({required String id}) async {
    final url = "https://mpl-connect.herokuapp.com/api/getNextPos/$id";
    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    String respBody = json.decode(response.body);
    // print("I is " + response.body);
    // print(respBody);
    // final String searchResp = respBody['_id'] ?? "";
    // print(searchResp);
    return respBody;
  }

  static Future<void> incCheckpoint({required String id}) async {
    final url = "https://mpl-connect.herokuapp.com/api/checkPointIncrease/$id";
    await http.patch(Uri.parse(url));
    return;
  }

  static Future<void> incPenalty({required String id}) async {
    final url = "https://mpl-connect.herokuapp.com/api/penaltyIncrease/$id";
    await http.patch(Uri.parse(url));
    return;
  }
}
