/// The result returned by the API after scoring a test
class ScoreResponse {
  final String type;
  final Map<String, dynamic> scores;
  final Map<String, dynamic> confidence;

  ScoreResponse({
    required this.type,
    required this.scores,
    required this.confidence,
  });

  /// Create a ScoreResponse from JSON data (comes from the API)
  factory ScoreResponse.fromJson(Map<String, dynamic> json) {
    return ScoreResponse(
      type: json['type'] ?? '',
      scores: Map<String, dynamic>.from(json['scores'] ?? {}),
      confidence: Map<String, dynamic>.from(json['confidence'] ?? {}),
    );
  }
}