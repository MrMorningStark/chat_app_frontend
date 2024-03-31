import 'package:flutter/material.dart';

class PrivacyAndTerms extends StatelessWidget {
  const PrivacyAndTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          text: 'Read our ',
          style: TextStyle(
            color:  Theme.of(context).textTheme.labelSmall!.color,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: 'Privacy Policy. ',
              style: TextStyle(
                color: Theme.of(context).highlightColor,
              ),
            ),
            const TextSpan(text: 'Tap "Agree and continue" to accept the '),
            TextSpan(
              text: 'Terms of Services.',
              style: TextStyle(
                color: Theme.of(context).highlightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
