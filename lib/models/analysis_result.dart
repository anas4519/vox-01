class AnalysisResult {
  final String summary;
  final String mood;
  final double moodConfidence;
  final int emotionalIntensity;
  final List<String> actionItems;
  final List<String> keywords;
  final String tone;
  final String keyQuote;
  final String nextStepSuggestion;
  final String sessionTitle;
  final int wordCount;
  final double speakingDuration;

  AnalysisResult({
    required this.summary,
    required this.mood,
    required this.moodConfidence,
    required this.emotionalIntensity,
    required this.actionItems,
    required this.keywords,
    required this.tone,
    required this.keyQuote,
    required this.nextStepSuggestion,
    required this.sessionTitle,
    required this.wordCount,
    required this.speakingDuration,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      summary: json['summary'] ?? '',
      mood: json['mood'] ?? 'Neutral',
      moodConfidence: (json['moodConfidence'] ?? 0.5).toDouble(),
      emotionalIntensity: json['emotionalIntensity'] ?? 5,
      actionItems: List<String>.from(json['actionItems'] ?? []),
      keywords: List<String>.from(json['keywords'] ?? []),
      tone: json['tone'] ?? 'Casual',
      keyQuote: json['keyQuote'] ?? '',
      nextStepSuggestion: json['nextStepSuggestion'] ?? '',
      sessionTitle: json['sessionTitle'] ?? 'Voice Note',
      wordCount: json['wordCount'] ?? 0,
      speakingDuration: (json['speakingDuration'] ?? 0.0).toDouble(),
    );
  }

  double get wordsPerMinute {
    if (speakingDuration == 0) return 0;
    return (wordCount / speakingDuration) * 60;
  }
}
