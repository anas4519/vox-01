# VOX-01 🎙️

> **Prototype** - An experimental voice analysis app powered by AI

<p align="center">
  <img src="https://img.shields.io/badge/Status-Prototype-orange" alt="Status: Prototype">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue" alt="Flutter">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey" alt="Platform">
  <img src="https://img.shields.io/badge/AI-Gemini%20%7C%20AssemblyAI-purple" alt="AI">
</p>

## ⚠️ Prototype Notice

**VOX-01** is an experimental prototype designed to explore voice-to-text transcription and AI-powered analysis capabilities. This is not production-ready software and is intended for development and testing purposes only.

## 🌟 Overview

VOX-01 is a Flutter-based mobile application that records voice input, transcribes it using speech-to-text technology, and provides comprehensive AI-powered analysis including mood detection, keyword extraction, and actionable insights.

### 🎯 Key Features

- 🎤 **Voice Recording** - Simple tap-to-record interface
- 📝 **Speech-to-Text** - Powered by AssemblyAI (or OpenAI Whisper)
- 🧠 **AI Analysis** - Google Gemini Pro integration for intelligent insights
- 🎨 **Dark Theme UI** - Sleek black and navy blue design
- 📊 **Comprehensive Analytics** - Word count, speaking duration, WPM tracking


## 🚀 Features in Detail

### Voice Analysis Capabilities

| Feature | Description |
|---------|-------------|
| 📝 **Transcript** | Full speech-to-text transcription |
| 📄 **Summary** | AI-generated concise summary |
| 🙂 **Mood Detection** | Emotional state with confidence level |
| 📊 **Emotional Intensity** | Scale from 1-10 with visual indicator |
| 🏷️ **Keywords** | Automatic topic and keyword extraction |
| 🎯 **Tone Analysis** | Formal, casual, urgent, etc. |
| 💭 **Key Quote** | Most impactful sentence highlighted |
| 💡 **Next Steps** | AI-suggested actions based on content |
| ✅ **Action Items** | Extracted tasks and to-dos |
| 📈 **Speech Analytics** | Duration, word count, and WPM |

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Speech-to-Text**: AssemblyAI API / OpenAI Whisper API
- **AI Analysis**: Google Gemini Pro API
- **Audio Recording**: `record` package
- **Styling**: Google Fonts (Source Code Pro)
- **State Management**: StatefulWidget (Prototype simplicity)

## 📋 Prerequisites

- Flutter SDK (3.0+)
- Dart SDK
- API Keys:
  - AssemblyAI API key (or OpenAI API key for Whisper)
  - Google Gemini Pro API key
- iOS/Android development environment

## 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/anas4519/vox-01.git
   cd vox-01
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API keys**
   
   Create a `.env` file in the project root:
   ```env
   ASSEMBLYAI_API_KEY=your_assemblyai_api_key_here
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Platform-Specific Setup

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to microphone to record your voice.</string>
```

### Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

## 🎨 Design System

- **Primary Color**: `#001F3F` (Navy Blue)
- **Background**: `#000000` (Black)
- **Surface**: `#0A0A0A` (Near Black)
- **Font**: Source Code Pro (Monospace)

## 🚧 Known Limitations

As a prototype, VOX-01 has several limitations:

- No user authentication or data persistence
- No cloud storage for recordings
- Limited error recovery
- iOS Simulator audio issues
- Single language support (English)
- No offline mode

## 🔮 Future Enhancements

Potential features for future versions:

- Multi-language support
- Cloud sync and storage
- Voice profiles and history
- Export functionality
- Real-time transcription
- Custom AI prompts
- Voice commands
- Sharing capabilities

## 🤝 Contributing

This is a prototype project for learning and experimentation. Feel free to fork and modify for your own use cases.

## ⚡ Quick Start Guide

1. **Record**: Tap the microphone button to start recording
2. **Stop**: Tap again to stop and process
3. **View**: Scroll through your comprehensive analysis
4. **Copy**: Tap copy icons to save any text section
5. **Reset**: Use the refresh button for a new recording

