import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentRecordingPath;
  DateTime? _recordingStartTime;

  Future<void> initialize() async {
    if (Platform.isIOS) {
      final status = await Permission.microphone.status;
      if (!status.isGranted) {
        final result = await Permission.microphone.request();
        if (!result.isGranted) {
          throw Exception('Microphone permission not granted');
        }
      }
    } else {
      final permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        throw Exception('Microphone permission not granted');
      }
    }
  }

  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getTemporaryDirectory();
      _currentRecordingPath =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _recordingStartTime = DateTime.now();

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentRecordingPath!,
      );
    }
  }

  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    _recordingStartTime = null;
    return path;
  }

  Duration? getRecordingDuration() {
    if (_recordingStartTime != null) {
      return DateTime.now().difference(_recordingStartTime!);
    }
    return null;
  }

  void dispose() {
    _recorder.dispose();
    if (_currentRecordingPath != null) {
      try {
        File(_currentRecordingPath!).deleteSync();
      } catch (e) {
        print('Error deleting file: $e');
      }
    }
  }
}
