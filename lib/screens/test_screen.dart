import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';
import '../models/test_item.dart';
import '../services/api_service.dart';

/// Test screen where the user answers personality questions.
/// Demonstrates: StatefulWidget with async data loading, HTTP GET request,
/// user interaction with radio buttons, and HTTP POST to submit answers.
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // ── State variables ──
  final ApiService _apiService = ApiService();

  List<TestItem> _questions = [];
  final Map<int, int> _answers = {}; // question index -> answer value (1-5)
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  /// Loads test questions from the API (HTTP GET request)
  Future<void> _loadQuestions() async {
    try {
      final questions = await _apiService.getTestItems();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Submits answers to the API (HTTP POST request) and navigates to result
  Future<void> _submitTest() async {
    // Guard: prevent double submission
    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final result = await _apiService.scoreTest(_answers);
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: {
          'typeCode': result.type,
          'confidence': result.confidence,
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _error = 'خطا در ارسال: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'اتصال اینترنت برقرار نیست',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'لطفاً اتصال اینترنت خود را بررسی کنید و دوباره تلاش کنید.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() { _isLoading = true; _error = null; });
                    _loadQuestions();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('تلاش مجدد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isSubmitting) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 24),
              Text('در حال تحلیل پاسخ‌ها...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final progress = _answers.length / _questions.length;
    final allAnswered = _answers.length == _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تست شخصیت'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: Column(
        children: [
          // ── Progress Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سؤال ${_currentIndex + 1} از ${_questions.length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          // ── Question Card ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildQuestionCard(question),
            ),
          ),

          // ── Submit Button (show when all answered) ──
          if (allAnswered)
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _submitTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: const Text('ارسال تست'),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the question card widget showing the question and Likert scale
  Widget _buildQuestionCard(TestItem question) {
    final likertLabels = [
      'کاملاً مخالفم',
      'مخالفم',
      'بی‌طرف',
      'موافقم',
      'کاملاً موافقم',
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question text
            Text(
              question.statement,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Likert scale options (1-5 radio buttons)
            ...List.generate(5, (index) {
              final value = index + 1;
              final isSelected = _answers[_currentIndex] == value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: isSelected
                      ? primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      setState(() => _answers[_currentIndex] = value);
                      // Auto-advance to next question or submit if last
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (!mounted) return;
                        if (_currentIndex < _questions.length - 1) {
                          setState(() => _currentIndex++);
                        } else {
                          // Last question answered — auto-submit
                          _submitTest();
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Radio circle
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                                width: 2,
                              ),
                              color: isSelected ? primaryColor : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              likertLabels[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected
                                    ? primaryColor
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            value.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: index * 80),
                    duration: 300.ms,
                  );
            }),

          ],
        ),
      ),
    );
  }


  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأیید'),
        content: const Text('آیا می‌خواهید از تست خارج شوید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لغو'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: const Text('تأیید'),
          ),
        ],
      ),
    );
  }
}