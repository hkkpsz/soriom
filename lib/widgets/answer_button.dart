import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool showAnswer;

  const AnswerButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
    this.showAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Colors.black87;

    if (showAnswer) {
      if (isCorrect) {
        backgroundColor = Colors.green;
        borderColor = Colors.green;
        textColor = Colors.white;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red;
        borderColor = Colors.red;
        textColor = Colors.white;
      }
    } else if (isSelected) {
      backgroundColor = Colors.blue.withValues(alpha: 0.1);
      borderColor = Colors.blue;
      textColor = Colors.blue;
    }

    return GestureDetector(
      onTap: showAnswer ? () {} : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
