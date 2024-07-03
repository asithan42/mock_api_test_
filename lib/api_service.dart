import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "https://api.mockfly.dev/mocks/cc75eb0b-1e4b-4dad-8834-4fba55e19227/getData";

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<void> postData(Map<String, dynamic> item) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to upload data");
    }
  }
}
