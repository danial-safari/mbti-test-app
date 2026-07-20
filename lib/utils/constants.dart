import 'package:flutter/material.dart';

/// API configuration
const String apiBaseUrl = 'https://personality.fyi/api/v1';

/// Main app color
const Color primaryColor = Color(0xFF3498DB);

/// All 16 MBTI personality type codes
const List<String> mbtiTypes = [
  'INTJ', 'INTP', 'ENTJ', 'ENTP',
  'INFJ', 'INFP', 'ENFJ', 'ENFP',
  'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
  'ISTP', 'ISFP', 'ESTP', 'ESFP',
];

/// Color assigned to each personality type
Map<String, Color> typeColors = {
  'INTJ': const Color(0xFF5C6BC0),
  'INTP': const Color(0xFF42A5F5),
  'ENTJ': const Color(0xFFEF5350),
  'ENTP': const Color(0xFFAB47BC),
  'INFJ': const Color(0xFF26A69A),
  'INFP': const Color(0xFF66BB6A),
  'ENFJ': const Color(0xFFFFA726),
  'ENFP': const Color(0xFFFFCA28),
  'ISTJ': const Color(0xFF8D6E63),
  'ISFJ': const Color(0xFF78909C),
  'ESTJ': const Color(0xFFEC407A),
  'ESFJ': const Color(0xFFFF7043),
  'ISTP': const Color(0xFF26C6DA),
  'ISFP': const Color(0xFF9CCC65),
  'ESTP': const Color.fromARGB(255, 255, 149, 88),
  'ESFP': const Color.fromARGB(255, 91, 93, 235),
};

/// Returns color for a personality type code
Color getTypeColor(String typeCode) {
  return typeColors[typeCode] ?? primaryColor;
}