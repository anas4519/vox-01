import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class MoodCard extends StatelessWidget {
  final AnalysisResult analysisResult;

  const MoodCard({
    super.key,
    required this.analysisResult,
  });

  String _getMoodEmoji(String mood) {
    final moodMap = {
      'Happy': '😊',
      'Sad': '😢',
      'Angry': '😠',
      'Excited': '🤩',
      'Anxious': '😰',
      'Neutral': '😐',
      'Frustrated': '😤',
      'Confident': '😎',
      'Worried': '😟',
      'Relaxed': '😌',
    };
    return moodMap[mood] ?? '🙂';
  }

  Color _getIntensityColor(int intensity) {
    if (intensity <= 3) return Colors.green;
    if (intensity <= 6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final confidence = (analysisResult.moodConfidence * 100).round();

    return Card(
      color: const Color(0xFF001F3F).withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🙂 Emotional Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _getMoodEmoji(analysisResult.mood),
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            analysisResult.mood,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF001F3F),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$confidence% confidence',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Intensity: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: analysisResult.emotionalIntensity / 10,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getIntensityColor(
                                    analysisResult.emotionalIntensity),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${analysisResult.emotionalIntensity}/10',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getIntensityColor(
                                  analysisResult.emotionalIntensity),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
