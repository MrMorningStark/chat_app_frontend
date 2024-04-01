import 'package:WhatsApp/api/api.dart';
import 'package:WhatsApp/constant.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:WhatsApp/provider/mainProvider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketProvider = Provider((ref) {
  // Replace 'https://your_socket_server_url' with the URL of your Socket.IO server.
  final socket = IO.io(BASE_URL, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  socket.connect();

  socket.on('connect', (_) {
    print('Connected to the socket server');
  });

  MyUser currUser = ref.read(userProvider)!;

  Future<void> initiateChat(String conversationId) async {
    ApiResponse apiResponse =
        await API.loadConversation(conversationId: conversationId);
    if (apiResponse.success) {
      List<Chat> chats = List.from(apiResponse.data['conversation'])
          .map((e) => Chat.fromJson(e))
          .toList();

      ref.read(chatProvider.notifier).setChat(chats);
    }
  }

  void sendMessage({required String toUID, required String message}) {
    Map<String, dynamic> mssg = {
      'toUID': toUID,
      'fromUID': currUser.uid,
      'message': message,
      'createdAt': DateTime.now().millisecondsSinceEpoch
    };
    socket.emit(SOCKET_ON.SEND_MESSAGE, mssg);
    ref.read(chatProvider.notifier).addChat(Chat.fromJson(mssg));
  }

  // Receive message that was sent by another user
  socket.on(currUser.uid, (data) {
    // toUID | fromUID | message | createdAt
    ref.read(chatProvider.notifier).addChat(Chat.fromJson(data));
  });

  void leaveChat(String toUID) {
    ref.read(chatProvider.notifier).setChat([]);
    // socket.emit(SOCKET_ON.LEAVE_CHAT, {"toUID": toUID});
    print('Left chat');
  }

  // when app goes in background or is closed disconnect from socket
  socket.on("disconnect", (_) {
    print('Disconnected from the socket server');
    socket.disconnect();
    socket.off(SOCKET_ON.MESSAGE_RECEIVED);
  });

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
