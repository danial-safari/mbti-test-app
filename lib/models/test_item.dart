/// A single test question with its axis (e.g. "I_E" for Introvert vs Extravert)
class TestItem {
  final int id;
  final String statement;
  final String axis;
  final String disagreePole;
  final String agreePole;

  TestItem({
    required this.id,
    required this.statement,
    required this.axis,
    required this.disagreePole,
    required this.agreePole,
  });

  /// Create a TestItem from JSON data (comes from the API)
  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(
      id: json['id'] ?? 0,
      statement: json['statement'] ?? '',
      axis: json['axis'] ?? '',
      disagreePole: json['disagreePole'] ?? '',
      agreePole: json['agreePole'] ?? '',
    );
  }
}