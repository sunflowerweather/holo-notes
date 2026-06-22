import 'package:flutter/material.dart';

import '../classes/day.dart';
import '../classes/note.dart';
import '../service/themes.dart';

void showHighlightedDialog({
  required BuildContext context,
  required ValueNotifier<Map<String, Day>> days,
  required String dateString,



  required void Function(String dateString) onChangeDate,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: background1Color,

        title: Text(
          'All highlighted words',
          style: TextStyle(color: foregroundColor),
        ),

        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ValueListenableBuilder<Map<String, Day>>(
            valueListenable: days,
            builder: (context, value, _) {

              final regex = RegExp(r'\|(.*?)\|');
              final List<String> highlightedWords = [];

              for (final day in value.values) {
                for (final note in day.notes) {
                  for (final match in regex.allMatches(note.text)) {
                    final word = match.group(1);

                    if (word != null && word.isNotEmpty) {
                      highlightedWords.add(word);
                    }
                  }
                }
              }

              if (highlightedWords.isEmpty) {
                return Center(
                  child: Text(
                    'No highlighted words',
                    style: TextStyle(color: foregroundColor),
                  ),
                );
              }

              final combinedText =
              highlightedWords.map((w) => '|$w|').join('\n');

              return ListView(
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 50),
                    color: backgroundNoteColor,
                    padding: const EdgeInsets.all(8),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



                        const SizedBox(height: 5),

                        RichText(
                          text: TextSpan(
                            children: _buildHighlightedText(combinedText),

                          ),

                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: accentColor),
            ),
          ),
        ],
      );
    },
  );
}

List<TextSpan> _buildHighlightedText(String text) {
  final List<TextSpan> spans = [];

  final regex = RegExp(r'\|(.*?)\|');

  int lastEnd = 0;

  for (final match in regex.allMatches(text)) {
    // Normal text before highlighted section
    if (match.start > lastEnd) {
      spans.add(
        TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(
            color: foregroundColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }


    spans.add(
      TextSpan(
        text: match.group(1),
        style: TextStyle(
          color: foregroundColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          backgroundColor: accentColor.withOpacity(0.5),
        ),
      ),
    );

    lastEnd = match.end;
  }

  // Remaining text after last match
  if (lastEnd < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(
          color: foregroundColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  return spans;
}