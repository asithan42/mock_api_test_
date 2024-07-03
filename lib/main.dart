// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'api_service.dart';
import 'database_helper.dart';

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
  List<Map<String, dynamic>> fetchedData = [];
  List<Map<String, dynamic>> databaseData = [];

  Future<void> fetchDataAndSaveToDB() async {
    try {
      fetchedData = await apiService.fetchData();
      for (var item in fetchedData) {
        await dbHelper.insertItem(item);
      }
      // ignore: duplicate_ignore

      print("Data saved to SQLite database");
      setState(() {}); // Update UI after saving data
    } catch (e) {
      print("Error fetching or saving data: $e");
    }
  }

  Future<void> displayData() async {
    try {
      databaseData = await dbHelper.getAllItems();
      print("Data retrieved from SQLite database");
      setState(() {}); // Update UI after fetching data
    } catch (e) {
      print("Error fetching data from database: $e");
    }
  }

  Future<void> uploadDataToAPI() async {
    try {
      List<Map<String, dynamic>> data = await dbHelper.getAllItems();
      for (var item in data) {
      
        await apiService.postData(item);
      }
      print("Data uploaded to API");
    } catch (e) {
      print("Error uploading data: $e");
    }
  }

  Future<void> clearDatabase() async {
    try {
      await dbHelper.clearTable('items');
      databaseData = []; // Clear local data list
      print("Database cleared");
      setState(() {}); // Update UI after clearing database
    } catch (e) {
      print("Error clearing database: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mock API Example"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: fetchDataAndSaveToDB,
                child: const Text("Fetch and Save Data"),
              ),
              ElevatedButton(
                onPressed: displayData,
                child: const Text("Display Data"),
              ),
              ElevatedButton(
                onPressed: uploadDataToAPI,
                child: const Text("Upload Data to API"),
              ),
              ElevatedButton(
                onPressed: clearDatabase,
                child: const Text("Clear Database"),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Text(
                "Database Data:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                children: databaseData
                    .map((item) => ListTile(
                          title: Text(item['name']),
                          subtitle: Text(item['description']),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
