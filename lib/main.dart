import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/voice_analyzer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print(
      'AssemblyAI API Key loaded: ${dotenv.env['ASSEMBLYAI_API_KEY']?.isNotEmpty ?? false}');
  runApp(const VoiceAnalyzerApp());
}

class VoiceAnalyzerApp extends StatelessWidget {
  const VoiceAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF001F3F),
        scaffoldBackgroundColor: const Color(0xFF000000),
        cardTheme: CardTheme(
          color: const Color(0xFF1A1A1A), // Slightly lighter than pure black
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFF001F3F),
              width: 1,
            ),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF001F3F).withOpacity(0.2),
        ),
        textTheme: GoogleFonts.sourceCodeProTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF001F3F),
          secondary: Color(0xFF001F3F),
          surface: Color(0xFF0A0A0A),
          background: Color(0xFF000000),
        ),
      ),
      home: const VoiceAnalyzerScreen(),
    );
  }
}
