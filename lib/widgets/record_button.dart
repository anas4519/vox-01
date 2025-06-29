import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback? onPressed;

  const RecordButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording ? Colors.red : const Color(0xFF001F3F),
          boxShadow: [
            BoxShadow(
              color: isRecording
                  ? Colors.red.withOpacity(0.3)
                  : const Color(0xFF001F3F).withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              key: ValueKey(isRecording),
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
