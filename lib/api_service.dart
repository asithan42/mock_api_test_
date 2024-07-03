import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://api.mockfly.dev/mocks/cc75eb0b-1e4b-4dad-8834-4fba55e19227/getData"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<void> postData(Map<String, dynamic> data) async {
    final response = await http.post(
        Uri.parse("https://api.mockfly.dev/mocks/cc75eb0b-1e4b-4dad-8834-4fba55e19227/getData"),
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print("Data posted successfully");
    } else {
      throw Exception("Failed to post data");
    }
  }
}
