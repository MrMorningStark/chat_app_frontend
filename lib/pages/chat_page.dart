import 'package:WhatsApp/components/chat/chat_bottom.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/helper/helper.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:WhatsApp/provider/mainProvider.dart';
import 'package:WhatsApp/provider/socketProvider.dart';
import 'package:WhatsApp/widgets/chatBubble.dart';
import 'package:WhatsApp/widgets/chatDateDivider.dart';
import 'package:WhatsApp/widgets/contactImage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  final MyUser toUser;
  const ChatPage({super.key, required this.toUser});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late MyUser currUser;
  late MyUser toUser;
  late SocketService mySocketProvider;
  late List<Chat> chats = [];

  TextEditingController chatController = TextEditingController();
  ScrollController chatScrollController = ScrollController();

  List<MyUser> users = [];
  bool isLoading = false;
  bool isChatBottom = true;
  String? chatDate = '';

  scrollToChatBottom() {
    chatScrollController.jumpTo(0);
  }

  @override
  void initState() {
    super.initState();
    currUser = ref.read(userProvider)!;
    toUser = widget.toUser;
    mySocketProvider = ref.read(socketProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToChatBottom();
    });
  }

  @override
  void dispose() {
    mySocketProvider.leaveChat(toUser.uid);
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
      mySocketProvider.sendMessage(
          toUID: toUser.uid, message: chatController.text.trim());
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
                    photoURL: toUser.photoURL,
                    size: 35,
                    onTapImage: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Text(
              toUser.displayName,
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
                bottom: MediaQuery.of(context).viewInsets.bottom + 3,
              ),
              child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.only(bottom: 5),
                  shrinkWrap: true,
                  controller: chatScrollController,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {

                    Widget chatBubble = ChatBubble(
                      message: chats[index].message,
                      type: chats[index].createdBy == currUser.uid
                          ? MessageType.self
                          : MessageType.other,
                      status: chats[index].status,
                      showNip: index == chats.length - 1 ||
                          chats[index + 1].createdBy != chats[index].createdBy,
                      createdAt: chats[index].createdAt,
                    );

                    // Get the message's date from the timestamp
                    DateTime messageDate = DateTime.fromMillisecondsSinceEpoch(
                        chats[index].createdAt);

                    // Get the previous message's date
                    DateTime? previousDate = chats.length > index + 1
                        ? DateTime.fromMillisecondsSinceEpoch(
                            chats[index + 1].createdAt)
                        : null;

                    if (previousDate != null) {
                      // Check if the message's date is different from the previous message's date
                      bool isNewDay = previousDate.day != messageDate.day ||
                          previousDate.month != messageDate.month ||
                          previousDate.year != messageDate.year;
                      if (isNewDay) {
                        return Column(
                          children: [
                            ChatDateDivider(
                              date: formatDateForChats(
                                  previousDate.millisecondsSinceEpoch),
                            ),
                            chatBubble,
                          ],
                        );
                      }
                    }

                    return chatBubble;
                  }),
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
