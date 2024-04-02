import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/helper/helper.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:WhatsApp/pages/chat_page.dart';
import 'package:WhatsApp/provider/mainProvider.dart';
import 'package:WhatsApp/provider/socketProvider.dart';
import 'package:WhatsApp/widgets/contactImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends ConsumerWidget {
  final String? photoURL;
  final String? displayName;
  final String? lastSeen;
  final String? caption;
  final MyUser? user;
  final double? imgSize;

  const ContactCard({
    super.key,
    this.photoURL,
    this.displayName,
    this.lastSeen = "",
    this.caption = "",
    this.user,
    this.imgSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Theme.of(context).splashColor),
      onTap: () async {
        if ((user?.isUserExist ?? true) == false) {
          String phone = user!.phoneNumber!.replaceAll(RegExp(r"[^0-9]"), "");
          var whatsappUrl = Uri.parse(
              "whatsapp://send?phone=91$phone&text=${Uri.encodeComponent("Download WhatsApp from here: https://rajatkhatri.in")}");
          try {
            await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
          } catch (e) {
            print("Error opening whatsapp: $e");
          }

          return;
        } else {
          MyUser currUser = ref.read(userProvider)!;
          ref.read(socketProvider).initiateChat(
              generateConversationId(currUser.uid, user!.uid), user!.uid);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatPage(toUser: user!)));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        width: double.maxFinite,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            ContactImage(
              photoURL: user?.photoURL ?? photoURL,
              displayName: user?.displayName ?? displayName,
              size: imgSize ?? 53,
            ),
            Positioned(
              top: 3,
              left: 65,
              child: Text(
                user?.displayName ?? displayName ?? "",
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5),
              ),
            ),
            // if (user!.lastMessage != null &&
            //     user!.lastMessage!.unReadMessages != 0)
            //   Positioned(
            //     bottom: 0,
            //     right: 5,
            //     child: Container(
            //       height: 25,
            //       width: 25,
            //       decoration: BoxDecoration(
            //         color: Theme.of(context)
            //             .floatingActionButtonTheme
            //             .backgroundColor,
            //         borderRadius: BorderRadius.circular(12.5),
            //       ),
            //       child: Center(
            //         child: Text(
            //           user!.lastMessage!.unReadMessages > 99
            //               ? '99+'
            //               : user!.lastMessage!.unReadMessages.toString(),
            //           style: const TextStyle(
            //             fontSize: 12,
            //             fontWeight: FontWeight.w400,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),

            Positioned(
              top: 3,
              right: 5,
              child: Text(
                lastSeen ?? "",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            Positioned(
              top: 27,
              left: 65,
              child: Row(
                children: [
                  if (user?.lastMessage != null &&
                      user?.lastMessage?.createdBy != user!.uid)
                    Row(
                      children: [
                        Icon(
                          user!.lastMessage!.status == MessageStatus.sent
                              ? Icons.done_rounded
                              : Icons.done_all_rounded,
                          // Icons.done_rounded,
                          // color: user!.lastMessage!.status == MessageStatus.read
                          //     ? Colors.blue
                          //     : Theme.of(context).hintColor,
                          color: Theme.of(context).hintColor,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 200,
                    child: Text(
                      user?.lastMessage?.message ??
                          user?.email ??
                          caption ??
                          "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (!user!.isUserExist)
              Positioned(
                top: 10,
                right: 5,
                child: Text(
                  "Invite",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                    letterSpacing: 1,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
