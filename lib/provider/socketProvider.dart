import 'package:WhatsApp/api/api.dart';
import 'package:WhatsApp/constant.dart';
import 'package:WhatsApp/db/db.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/helper/helper.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:WhatsApp/provider/mainProvider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketProvider = Provider((ref) {
  // Replace 'https://your_socket_server_url' with the URL of your Socket.IO server.
  final socket = IO.io(BASE_URL, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  socket.connect();

  MyUser currUser = ref.read(userProvider)!;

  socket.onConnect((_) {
    print('connected');
    socket.emit(SOCKET_ON.USER_STATUS, {'uid': currUser.uid, 'online': true});
  });

  Future<void> initiateChat(String conversationId, String toUID) async {
    ref.read(currConversationID.notifier).state = conversationId;
    List<Chat> last20mssg = await DatabaseHelper().getChat(conversationId);
    if (last20mssg.isNotEmpty) {
      ref.read(chatProvider.notifier).setChat(chats: last20mssg);
    }
    ApiResponse apiResponse =
        await API.loadConversation(conversationId: conversationId);
    if (apiResponse.success) {
      List<Chat> chats = List.from(apiResponse.data['conversation'] ?? [])
          .map((e) => Chat.fromJson(e))
          .toList();
      // check if last message is status is delivered
      if (chats.isNotEmpty) {
        Chat lastChat = chats.first;
        if ((lastChat.status == MessageStatus.delivered ||
                lastChat.status == MessageStatus.sent) &&
            lastChat.createdBy != currUser.uid) {
          socket.emit(SOCKET_ON.MESSAGE_STATUS, {
            'toUID': toUID,
            'conversationId': conversationId,
            'status': MessageStatus.read
          });
        }
      }

      ref
          .read(chatProvider.notifier)
          .setChat(chats: chats, conversationId: conversationId);
    }
  }

  void sendMessage({required String toUID, required String message}) {
    Map<String, dynamic> mssg = {
      'toUID': toUID,
      'fromUID': currUser.uid,
      'message': message,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'status': MessageStatus.sent,
    };
    socket.emit(SOCKET_ON.SEND_MESSAGE, mssg);
    ref.read(chatProvider.notifier).addChat(Chat.fromJson(mssg));
  }

  socket.on("statusUpdate-${currUser.uid}", (data) {
    // conversationId | status
    if (ref.read(currConversationID.notifier).state != null &&
        data['conversationId'] == ref.read(currConversationID.notifier).state) {
      ref
          .read(chatProvider.notifier)
          .changeChatStatus(data['conversationId'], data['status']);
    }
  });

  // Receive message that was sent by another user
  socket.on(currUser.uid, (data) async {
    // toUID | fromUID | message | createdAt | status
    playMessageRecievedSound();
    ref.read(chatProvider.notifier).addChat(Chat.fromJson(data));
    ref.read(recentChatProvider.notifier).loadRecentChats();
    String fromUid = data["fromUID"];
    socket.emit('statusUpdate-$fromUid', {
      "conversationId": generateConversationId(data["fromUID"], currUser.uid),
      "status": MessageStatus.read
    });
  });

  void leaveChat(String toUID) {
    ref.read(chatProvider).clear();
    ref.read(recentChatProvider.notifier).loadRecentChats();
    // socket.emit(SOCKET_ON.LEAVE_CHAT, {"toUID": toUID});
    print('Left chat');
  }

  socket.on("hello${currUser.uid}", (data) {
    print(data);
    if (data.length > 1 && data[1] is Function) {
      // Check if the second element is a function
      Function ackFunction = data[1];
      ackFunction('world'); // Call the ack function
    } else {
      print("Ack function not found or invalid data structure.");
    }
  });

  socket.onError((_) {
    socket.connect();
  });

  socket.on('disconnect', (_) {
    print('Socket disconnected');
  });

  WidgetsBinding.instance
      .addObserver(AppLifecycleListener(socket: socket, uid: currUser.uid));

  return SocketService(
    initiateChat: initiateChat,
    sendMessage: sendMessage,
    leaveChat: leaveChat,
  );
});

playMessageRecievedSound() async {
  await AudioPlayer().play(
    volume: 0.5,
    AssetSource('sounds/notification.mp3'),
    position: const Duration(milliseconds: 500),
  );
}

class AppLifecycleListener extends WidgetsBindingObserver {
  final IO.Socket socket;
  final String uid;

  AppLifecycleListener({required this.socket, required this.uid});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      socket.connect();
      socket.emit(SOCKET_ON.USER_STATUS, {'uid': uid, 'online': true});
      print('App is resumed');
    }
  }
}
