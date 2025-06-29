import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../services/audio_recorder_service.dart';
import '../services/transcription_service.dart';
import '../services/gemini_service.dart';
import '../models/analysis_result.dart';
import '../widgets/record_button.dart';
import '../widgets/analysis_card.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/mood_card.dart';
import '../widgets/keywords_card.dart';
import '../widgets/analytics_card.dart';

class VoiceAnalyzerScreen extends StatefulWidget {
  const VoiceAnalyzerScreen({super.key});

  @override
  State<VoiceAnalyzerScreen> createState() => _VoiceAnalyzerScreenState();
}

class _VoiceAnalyzerScreenState extends State<VoiceAnalyzerScreen> {
  final AudioRecorderService _audioRecorder = AudioRecorderService();
  final TranscriptionService _transcriptionService = TranscriptionService();
  final GeminiService _geminiService = GeminiService();

  bool _isRecording = false;
  bool _isProcessing = false;
  String? _transcript;
  AnalysisResult? _analysisResult;
  DateTime? _recordingStartTime;
  double _recordingDuration = 0;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _audioRecorder.initialize();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _handleRecordingToggle() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
      _transcript = null;
      _analysisResult = null;
      _recordingStartTime = DateTime.now();
    });
    await _audioRecorder.startRecording();
  }

  Future<void> _stopRecording() async {
    // Calculate recording duration
    if (_recordingStartTime != null) {
      _recordingDuration =
          DateTime.now().difference(_recordingStartTime!).inMilliseconds /
              1000.0;
    }

    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });

    try {
      // Mock mode for iOS Simulator
      if (Platform.isIOS && _recordingDuration < 2) {
        print('🎭 Using mock data for testing');
        const mockTranscript =
            "I need to schedule a meeting with the marketing team tomorrow at 2 PM to discuss the new product launch. "
            "Also, remind me to review the quarterly sales report and send feedback to John by Friday. "
            "I'm feeling quite excited and energized about the new project launch next month. "
            "The client seemed really happy with our proposal yesterday.";

        setState(() {
          _transcript = mockTranscript;
          _recordingDuration = 12.5; // Mock duration
        });

        final analysis = await _geminiService.analyzeTranscript(mockTranscript,
            audioDuration: _recordingDuration);
        setState(() {
          _analysisResult = analysis;
        });
        return;
      }

      final audioPath = await _audioRecorder.stopRecording();
      if (audioPath != null) {
        // Transcribe audio
        final transcript = await _transcriptionService.transcribe(audioPath);

        setState(() {
          _transcript = transcript;
        });

        // Analyze with Gemini
        if (transcript.isNotEmpty) {
          final analysis = await _geminiService.analyzeTranscript(
            transcript,
            audioDuration: _recordingDuration,
          );
          setState(() {
            _analysisResult = analysis;
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error processing audio: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade900,
      ),
    );
  }

  void _resetRecording() {
    setState(() {
      _transcript = null;
      _analysisResult = null;
      _recordingDuration = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _analysisResult?.sessionTitle ?? 'VOX-01',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: const Color(0xFF001F3F),
        elevation: 0,
        actions: [
          if (_transcript != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetRecording,
              tooltip: 'New Recording',
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: RecordButton(
                    isRecording: _isRecording,
                    onPressed: _isProcessing ? null : _handleRecordingToggle,
                  ),
                ),
                const SizedBox(height: 40),
                if (_transcript != null) ...[
                  AnalysisCard(
                    title: '📝 Transcript',
                    content: _transcript!,
                    onCopy: () => _copyToClipboard(_transcript!),
                  ),
                  const SizedBox(height: 16),
                  if (_analysisResult != null) ...[
                    AnalysisCard(
                      title: '💭 Key Quote',
                      content: '"${_analysisResult!.keyQuote}"',
                      isHighlighted: true,
                      onCopy: () => _copyToClipboard(_analysisResult!.keyQuote),
                    ),
                    const SizedBox(height: 16),
                    AnalysisCard(
                      title: '📄 Summary',
                      content: _analysisResult!.summary,
                      onCopy: () => _copyToClipboard(_analysisResult!.summary),
                    ),
                    const SizedBox(height: 16),
                    MoodCard(analysisResult: _analysisResult!),
                    const SizedBox(height: 16),
                    KeywordsCard(keywords: _analysisResult!.keywords),
                    const SizedBox(height: 16),
                    AnalysisCard(
                      title: '🎯 Tone',
                      content: _analysisResult!.tone,
                      isHighlighted: false,
                    ),
                    const SizedBox(height: 16),
                    AnalysisCard(
                      title: '💡 Next Step',
                      content: _analysisResult!.nextStepSuggestion,
                      onCopy: () =>
                          _copyToClipboard(_analysisResult!.nextStepSuggestion),
                    ),
                    const SizedBox(height: 16),
                    if (_analysisResult!.actionItems.isNotEmpty)
                      _buildActionItemsCard(),
                    const SizedBox(height: 16),
                    AnalyticsCard(analysisResult: _analysisResult!),
                  ],
                ],
              ],
            ),
          ),
          if (_isProcessing) const LoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildActionItemsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '✅ Action Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                    size: 20,
                  ),
                  onPressed: () => _copyToClipboard(
                    _analysisResult!.actionItems.join('\n'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._analysisResult!.actionItems.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: Colors.white60,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white60),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
