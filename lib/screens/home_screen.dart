import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';

/// Home screen - the main screen of the app.
/// Demonstrates: StatelessWidget, GridView, navigation with Navigator.pushNamed
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with settings button
            SliverAppBar(
              floating: true,
              title: const Text('پرسونالیتی فای'),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Hero Banner ──
                  _buildHeroBanner(context),
                  const SizedBox(height: 24),

                  // ── Start Test Button ──
                  _buildStartTestButton(context),
                  const SizedBox(height: 32),

                  // ── Section title ──
                  Text(
                    'انواع شخصیت',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // ── Grid of all 16 MBTI types ──
                  _buildTypeGrid(context),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Banner at the top of the home screen
  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.psychology_outlined, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          const Text(
            'شخصیت خود را کشف کنید',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تست شخصیت‌شناسی MBTI را انجام دهید و نوع شخصیت واقعی خود را بشناسید.',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  /// Big button to start the personality test
  Widget _buildStartTestButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/test'),
        label: const Text(
          'شروع تست شخصیت',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .scale(begin: const Offset(0.95, 0.95));
  }

  /// Grid showing all 16 personality type codes
  Widget _buildTypeGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: mbtiTypes.length,
      itemBuilder: (context, index) {
        final type = mbtiTypes[index];
        final color = getTypeColor(type);

        return Card(
          elevation: 0,
          color: color.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/personality', arguments: type);
            },
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Text(
                type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: 400 + (index * 50)),
              duration: 300.ms,
            );
      },
    );
  }
}