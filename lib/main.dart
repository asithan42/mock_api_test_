import 'package:flutter/material.dart';
import 'package:mock_api_test/database.dart';

import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> fetchDataAndSaveToDB() async {
    try {
      List<Map<String, dynamic>> data = await apiService.fetchData();
      for (var item in data) {
        await dbHelper.insertItem(item);
      }
      // ignore: avoid_print
      print("Data saved to SQLite database");
      _loadData(); // Refresh data after fetching
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching or saving data: $e");
    }
  }

  Future<void> uploadData() async {
    try {
      List<Map<String, dynamic>> data = await dbHelper.getAllItems();
      for (var item in data) {
        // Post each item to your API
        await apiService.postData(item);
      }
      print("Data uploaded to API");
    } catch (e) {
      print("Error uploading data: $e");
    }
  }

  Future<void> _loadData() async {
    final data = await dbHelper.getAllItems();
    setState(() {
      _items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mock API Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: fetchDataAndSaveToDB,
              child: const Text("Fetch and Save Data"),
            ),
            ElevatedButton(
              onPressed: uploadData,
              child: const Text("Upload Data"),
            ),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text("No data found"))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text(item['description']),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
