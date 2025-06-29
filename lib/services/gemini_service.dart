import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/analysis_result.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<AnalysisResult> analyzeTranscript(String transcript,
      {double? audioDuration}) async {
    final wordCount = transcript
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;

    final prompt = '''
You are an advanced assistant analyzing a user's spoken input. Analyze the following transcript and provide a comprehensive analysis.

Transcript:
"$transcript"

Provide your analysis in the following JSON format:
{
  "summary": "A concise 2-3 sentence summary of what the user said",
  "mood": "The user's emotional state (e.g., Happy, Sad, Angry, Excited, Anxious, Neutral, Frustrated, Confident)",
  "moodConfidence": 0.0 to 1.0 (confidence level of mood detection),
  "emotionalIntensity": 1 to 10 (1 being very calm, 10 being very intense),
  "actionItems": ["actionable task 1", "actionable task 2", ...],
  "keywords": ["keyword1", "keyword2", "keyword3", "keyword4", "keyword5"] (extract 3-5 key topics or phrases),
  "tone": "Describe the tone in 1-2 words (e.g., Formal, Casual, Agitated, Reflective, Professional, Friendly, Urgent)",
  "keyQuote": "The single most important or impactful sentence from the transcript",
  "nextStepSuggestion": "One helpful suggestion for what the user should do next based on this conversation",
  "sessionTitle": "A short, descriptive title for this recording (3-5 words)",
  "wordCount": $wordCount,
  "speakingDuration": ${audioDuration ?? 0}
}

Important guidelines:
- Be specific and accurate in your analysis
- Extract actual keywords from the text, not generic terms
- The key quote should be an exact quote from the transcript
- The next step suggestion should be actionable and relevant
- The session title should capture the essence of the conversation
''';

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 2000,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];

        // Extract JSON from the response
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
        if (jsonMatch != null) {
          final jsonString = jsonMatch.group(0);
          final analysisJson = jsonDecode(jsonString!);

          // Ensure wordCount and duration are set correctly
          analysisJson['wordCount'] = wordCount;
          analysisJson['speakingDuration'] = audioDuration ?? 0;

          return AnalysisResult.fromJson(analysisJson);
        }

        throw Exception('Failed to parse Gemini response');
      } else {
        throw Exception('Gemini API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in Gemini analysis: $e');
      // Return a default analysis if API fails
      return AnalysisResult(
        summary: 'Unable to generate summary',
        mood: 'Unknown',
        moodConfidence: 0.0,
        emotionalIntensity: 5,
        actionItems: [],
        keywords: [],
        tone: 'Unknown',
        keyQuote: '',
        nextStepSuggestion: 'Please try recording again',
        sessionTitle: 'Voice Note',
        wordCount: wordCount,
        speakingDuration: audioDuration ?? 0,
      );
    }
  }
}
