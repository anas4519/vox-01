import 'package:flutter/material.dart';

class AnalysisCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onCopy;
  final bool isHighlighted;

  const AnalysisCard({
    super.key,
    required this.title,
    required this.content,
    this.onCopy,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isHighlighted
          ? const Color.fromARGB(255, 8, 14, 19).withOpacity(0.2)
          : Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                if (onCopy != null)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: onCopy,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isHighlighted ? Colors.white70 : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
