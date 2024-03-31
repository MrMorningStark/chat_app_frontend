import 'package:WhatsApp/styles/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatBottom extends StatelessWidget {
  final TextEditingController chatController;
  final VoidCallback onSendMessage;
  const ChatBottom(
      {super.key, required this.chatController, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          padding: const EdgeInsets.all(2),
          child: Row(
            children: [
              PhysicalModel(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).cardColor,
                elevation: 5.0,
                shadowColor: Theme.of(context).cardColor,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 140),
                  width: MediaQuery.of(context).size.width - 60,
                  child: TextFormField(
                    controller: chatController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      hintText: "Message",
                      prefixIconColor: Theme.of(context).hintColor,
                      suffixIconColor: Theme.of(context).hintColor,
                      prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                      suffixIcon: RotatedBox(
                        quarterTurns: 1,
                        child: Transform.rotate(
                            angle: 180, child: const Icon(Icons.attach_file)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: PhysicalModel(
                  borderRadius: BorderRadius.circular(23),
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor!,
                  elevation: 5.0,
                  shadowColor: Theme.of(context).cardColor,
                  child: IconButton(
                    alignment: Alignment.centerRight,
                    color: Theme.of(context).primaryColor,
                    onPressed: onSendMessage,
                    icon: Icon(
                      Icons.send,
                      color: isDarkMode
                          ? whatsappThemeDark.whiteColor
                          : whatsappThemeLight.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


    // if (!isChatBottom)
    //           Positioned(
    //             bottom: MediaQuery.of(context).viewInsets.bottom + 60,
    //             right: 12,
    //             height: 34,
    //             width: 34,
    //             // textField for chatting
    //             child: PhysicalModel(
    //               borderRadius: BorderRadius.circular(18),
    //               color: Theme.of(context).cardColor,
    //               elevation: 5.0,
    //               shadowColor: Theme.of(context).cardColor,
    //               child: Center(
    //                 child: IconButton(
    //                   alignment: Alignment.center,
    //                   onPressed: scrollToChatBottom,
    //                   icon: Center(
    //                     child: Icon(
    //                       Icons.keyboard_double_arrow_down_sharp,
    //                       color: Theme.of(context).hintColor,
    //                       size: 20,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
         