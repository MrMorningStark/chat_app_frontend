import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/helper/helper.dart';
import 'package:WhatsApp/styles/theme.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final int type;
  final int status;
  final bool showNip;
  final int createdAt;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.type,
      required this.status,
      required this.showNip,
      required this.createdAt});

  @override
  Widget build(BuildContext context) {
    const String space = "                 ";
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      stick: true,
      radius: const Radius.circular(12.0),
      nip: showNip ? BubbleNip.leftTop : BubbleNip.no,
      color: isDarkMode
          ? Theme.of(context).appBarTheme.backgroundColor
          : whatsappThemeLight.whiteColor,
      elevation: 1 * px,
      margin:
          BubbleEdges.only(top: 8.0, right: 50.0, left: showNip ? 0.0 : 8.0),
      alignment: Alignment.topLeft,
      padding: const BubbleEdges.only(bottom: 0),
    );

    BubbleStyle styleMe = BubbleStyle(
      stick: true,
      radius: const Radius.circular(12.0),
      nip: showNip ? BubbleNip.rightTop : BubbleNip.no,
      color: isDarkMode
          ? whatsappThemeDark.chatBubbleBackgroundColor
          : whatsappThemeLight.chatBubbleBackgroundColor,
      elevation: 1 * px,
      margin:
          BubbleEdges.only(top: 8.0, left: 50.0, right: showNip ? 0.0 : 8.0),
      alignment: Alignment.topRight,
      padding: const BubbleEdges.only(bottom: 0),
    );

    return Bubble(
      style: type == MessageType.self ? styleMe : styleSomebody,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              message + space,
              style: TextStyle(
                  color: isDarkMode
                      ? whatsappThemeDark.whiteColor
                      : whatsappThemeLight.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Text(
                    formatDate(createdAt),
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      letterSpacing: 0,
                      fontSize: 12,
                    ),
                  ),
                  if (type == MessageType.self)
                    const SizedBox(
                      width: 5,
                    ),
                  if (type == MessageType.self)
                    Icon(
                      status == MessageStatus.sent
                          ? Icons.done_rounded
                          : Icons.done_all_rounded,
                      color: status == MessageStatus.read
                          ? Colors.blue
                          : Theme.of(context).hintColor,
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
