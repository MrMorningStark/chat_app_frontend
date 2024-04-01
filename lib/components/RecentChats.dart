import 'package:WhatsApp/helper/helper.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:WhatsApp/provider/mainProvider.dart';
import 'package:WhatsApp/provider/socketProvider.dart';
import 'package:WhatsApp/widgets/contactCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentChats extends ConsumerStatefulWidget {
  const RecentChats({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecentChatsState();
}

class _RecentChatsState extends ConsumerState<RecentChats> {
  late List<MyUser> recentChats = [];

  @override
  void initState() {
    super.initState();
    ref.read(socketProvider);
  }

  @override
  Widget build(BuildContext context) {
    recentChats = ref.watch(recentChatProvider);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: recentChats.length,
          itemBuilder: (context, index) => ContactCard(
            user: recentChats[index],
            lastSeen: formatDateForRecentChats(
                recentChats[index].lastMessage?.createdAt ??
                    DateTime.now().millisecondsSinceEpoch),
          ),
        ));
  }
}
