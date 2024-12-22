import 'package:flutter/material.dart';

// This widget is used to display truncated text to a maximum length
// It can be used to make sure card elements are of the same size
class TruncatedText extends StatelessWidget {
  final String text;
  final int maxLength;
  final TextStyle? style;

  const TruncatedText(
      {super.key,
      required this.text,
      required this.maxLength,
      required this.style});

  static String truncate(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength - 3)}...';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      truncate(text, maxLength),
      style: style,
    );
  }
}
