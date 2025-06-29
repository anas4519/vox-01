import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TranscriptionService {
  final String _apiKey = dotenv.env['ASSEMBLYAI_API_KEY'] ?? '';
  final String _uploadUrl = 'https://api.assemblyai.com/v2/upload';
  final String _transcriptUrl = 'https://api.assemblyai.com/v2/transcript';

  Future<String> transcribe(String audioPath) async {
    // Step 1: Upload audio file
    final uploadedUrl = await _uploadAudio(audioPath);

    // Step 2: Request transcription
    final transcriptId = await _requestTranscription(uploadedUrl);

    // Step 3: Poll for results
    return await _pollForResults(transcriptId);
  }

  Future<String> _uploadAudio(String audioPath) async {
    final file = File(audioPath);
    final bytes = await file.readAsBytes();

    final response = await http.post(
      Uri.parse(_uploadUrl),
      headers: {
        'authorization': _apiKey,
        'content-type': 'application/octet-stream',
      },
      body: bytes,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['upload_url'];
    } else {
      throw Exception('Failed to upload audio');
    }
  }

  Future<String> _requestTranscription(String audioUrl) async {
    final response = await http.post(
      Uri.parse(_transcriptUrl),
      headers: {
        'authorization': _apiKey,
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'audio_url': audioUrl,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to request transcription');
    }
  }

  Future<String> _pollForResults(String transcriptId) async {
    final url = '$_transcriptUrl/$transcriptId';

    while (true) {
      final response = await http.get(
        Uri.parse(url),
        headers: {'authorization': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'];

        if (status == 'completed') {
          print('Data : ${data['text']}');
          return data['text'] ?? '';
        } else if (status == 'error') {
          throw Exception('Transcription failed');
        }

        // Wait before polling again
        await Future.delayed(const Duration(seconds: 1));
      } else {
        throw Exception('Failed to get transcription status');
      }
    }
  }
}
