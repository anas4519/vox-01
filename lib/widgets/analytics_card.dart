import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class AnalyticsCard extends StatelessWidget {
  final AnalysisResult analysisResult;

  const AnalyticsCard({
    super.key,
    required this.analysisResult,
  });

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).round();
    return '${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Speech Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                  icon: Icons.timer_outlined,
                  label: 'Duration',
                  value: _formatDuration(analysisResult.speakingDuration),
                ),
                _buildMetric(
                  icon: Icons.text_fields,
                  label: 'Words',
                  value: analysisResult.wordCount.toString(),
                ),
                _buildMetric(
                  icon: Icons.speed,
                  label: 'WPM',
                  value: analysisResult.wordsPerMinute.round().toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF001F3F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF001F3F).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white60,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white60, // Navy text for better contrast
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white60, // Darker gray for readability
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
