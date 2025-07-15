import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/test_item.dart';
import '../models/score_response.dart';

/// Service class that handles all HTTP requests to the Personality FYI API.
/// This demonstrates how to make GET and POST requests using the http package.
class ApiService {
  /// Fetches the list of test questions from the API.
  /// Returns a list of TestItem objects.
  Future<List<TestItem>> getTestItems() async {
    final url = Uri.parse('$apiBaseUrl/test/items');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // API returns {"items": [...]} — we extract the array from the "items" key
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['items'];
      return data.map((item) => TestItem.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت سوالات: ${response.statusCode}');
    }
  }

  /// Submits the user's answers to the API and gets the personality type result.
  /// [answers] is a map of question index to answer value (1-5).
  Future<ScoreResponse> scoreTest(Map<int, int> answers) async {
    final url = Uri.parse('$apiBaseUrl/test/score');
    // API expects answers as an array of 32 values (1-5)
    final answersList = List<int>.filled(32, 3); // default neutral
    answers.forEach((index, value) {
      if (index < 32) answersList[index] = value;
    });
    final body = jsonEncode({'answers': answersList});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ScoreResponse.fromJson(data);
    } else {
      throw Exception('خطا در ارسال پاسخ‌ها: ${response.statusCode}');
    }
  }
}