import 'package:WhatsApp/components/chat/chat_bottom.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/helper/helper.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:WhatsApp/provider/mainProvider.dart';
import 'package:WhatsApp/provider/socketProvider.dart';
import 'package:WhatsApp/widgets/chatBubble.dart';
import 'package:WhatsApp/widgets/contactImage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  final MyUser user2;
  const ChatPage({super.key, required this.user2});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late MyUser user1;
  late MyUser user2;
  late SocketService mySocketProvider;
  late List<Chat> chats = [];

  TextEditingController chatController = TextEditingController();
  ScrollController chatScrollController = ScrollController();

  List<MyUser> users = [];
  bool isLoading = false;
  bool isChatBottom = true;
  String? roomID = null;
  String? chatDate = '';

  scrollToChatBottom() {
    setState(() {
      chatScrollController.jumpTo(0);
    });
  }

  @override
  void initState() {
    super.initState();
    user1 = ref.read(userProvider)!;
    user2 = widget.user2;
    mySocketProvider = ref.read(socketProvider);
    setState(() {
      roomID = mySocketProvider.initiateChat(user1.uid, user2.uid);
    });
  }

  @override
  void dispose() {
    mySocketProvider.leaveChat(roomID!);
    chatController.dispose();
    super.dispose();
  }

  playMessageSentSound() async {
    await AudioPlayer().play(
      volume: 0.1,
      AssetSource('sounds/message_sent.mp3'),
      position: const Duration(milliseconds: 500),
    );
  }

  onSendMessage() async {
    if (chatController.text.trim().isEmpty) {
      return;
    }
    if (chatController.text.trim().isNotEmpty) {
      playMessageSentSound();
      mySocketProvider.sendMessage(roomID!, user2, chatController.text.trim(),
          chats.isNotEmpty ? chats[0].unReadMessages++ : 0);
      setState(() {
        ref.read(chatProvider.notifier).saveChatToLocalStorage(
            generateRoomId(user1.uid, user2.uid),
            Chat(
              text: chatController.text.trim(),
              createdAt: DateTime.now().millisecondsSinceEpoch,
              user: MyUser(
                uid: FirebaseAuth.instance.currentUser!.uid,
                displayName: FirebaseAuth.instance.currentUser!.displayName!,
                photoURL: FirebaseAuth.instance.currentUser!.photoURL!,
                phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber,
                email: FirebaseAuth.instance.currentUser!.email!,
              ),
              type: MessageType.self,
              status: MessageStatus.sent,
              unReadMessages: 0,
            ));
      });
      chatController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    chats = ref.watch(chatProvider);
    // on chats length change scroll to bottom
    ref.listen(chatProvider, (previous, next) {
      scrollToChatBottom();
    });

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).appBarTheme.iconTheme!.color,
                    size: Theme.of(context).appBarTheme.iconTheme!.size,
                  ),
                  ContactImage(
                    photoURL: user2.photoURL,
                    size: 35,
                    onTapImage: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Text(
              user2.displayName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Routes.navigateTo(route: Routes.SEARCH_PAGE);
            },
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {
              // Routes.navigateTo(route: Routes.SEARCH_PAGE);
            },
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 55),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isDarkMode
                    ? "assets/images/chat_bg_dark.png"
                    : "assets/images/chat_bg_light.png"),
                opacity: isDarkMode ? 0.1 : 1.0,
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 0,
                  left: 8,
                  right: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 3),
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(bottom: 5),
                shrinkWrap: true,
                controller: chatScrollController,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  //  if created at yesterday ,today or date then show time
                  String prevFormattedDate = formatDateForRecentChats(
                      chats[index != 0 ? index - 1 : 0].createdAt);
                  String formattedDate =
                      formatDateForRecentChats(chats[index].createdAt);
                  if (prevFormattedDate.contains('M')) {
                    prevFormattedDate = "Today";
                  }
                  if (formattedDate.contains('M')) {
                    formattedDate = "Today";
                  }

                  if (prevFormattedDate != formattedDate) {
                    return Column(
                      children: [
                        Text(formattedDate),
                        ChatBubble(
                          message: chats[index].text,
                          type: chats[index].type,
                          status: chats[index].status,
                          showNip: index == 0
                              ? true
                              : chats[index - 1].type == chats[index].type
                                  ? false
                                  : true,
                          createdAt: chats[index].createdAt,
                        )
                      ],
                    );
                  } else {
                    return ChatBubble(
                      message: chats[index].text,
                      type: chats[index].type,
                      status: chats[index].status,
                      showNip: index == 0
                          ? true
                          : chats[index - 1].type == chats[index].type
                              ? false
                              : true,
                      createdAt: chats[index].createdAt,
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: ChatBottom(
              chatController: chatController,
              onSendMessage: onSendMessage,
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
