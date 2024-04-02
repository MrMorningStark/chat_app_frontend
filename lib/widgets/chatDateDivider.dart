import 'package:flutter/material.dart';

class ChatDateDivider extends StatelessWidget {
  final String date;
  const ChatDateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 8.0,
      ),
      child: Text(
        date,
        style: TextStyle(
          color: Theme.of(context).primaryIconTheme.color,
        ),
      ),
    );
  }
}
