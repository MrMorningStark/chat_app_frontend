import 'package:WhatsApp/constant.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/helper/helper.dart';
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

  bool isChatPageOpen = false;
  String initiateChat(String userID_1, String userID_2) {
    isChatPageOpen = true;
    // Generate a consistent room ID based on user IDs
    final roomId = generateRoomId(userID_1, userID_2);
    socket.emit(SOCKET_ON.INITIATE_CHAT, roomId);
    print('Initiated chat with room ID: $roomId');
    return roomId;
  }

  socket.on(SOCKET_ON.CHAT_INITIATED, (data) {
    print('chat initiated');
    print(data);
  });

  socket.on(SOCKET_ON.RECEIVE_MESSAGE, (data) async {
    String roomID = data['roomID'];
    String message = data['message'];
    MyUser user = MyUser.fromJson(data['user']);
    int unReadMessages = data['unReadMessages'];
    bool isOnline = data['isOnline'] ?? false;
    MyUser currUser = ref.read(userProvider)!;
    // if (currUser.uid != user.uid) {
    //   return;
    // }
    playMessageRecievedSound();
    await ref.read(chatProvider.notifier).saveChatToLocalStorage(
        roomID,
        Chat(
            type: MessageType.other,
            status: isOnline
                ? isChatPageOpen
                    ? MessageStatus.read
                    : MessageStatus.delivered
                : MessageStatus.sent,
            text: message,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            unReadMessages: isOnline
                ? isChatPageOpen
                    ? 0
                    : unReadMessages + 1
                : unReadMessages + 1,
            user: user));
    await ref.read(recentChatProvider.notifier).refreshRecentChats(currUser);
    socket.emit(SOCKET_ON.MESSAGE_RECEIVED, {
      "roomID": roomID,
      "user": user.toJson(),
      "status": isOnline
          ? isChatPageOpen
              ? MessageStatus.read
              : MessageStatus.delivered
          : MessageStatus.sent
    });
    print('Received message: $message from user: ${user.displayName}');
  });

  socket.on(SOCKET_ON.MESSAGE_RECEIVED, (data) async {
    String roomID = data['roomID'];
    MyUser user = MyUser.fromJson(data['user']);
    int status = data['status'];
    await ref.read(chatProvider.notifier).changeMessageStatus(roomID, status);
    print('Message received from user: ${user.displayName}');
  });

  void sendMessage(
      String roomID, MyUser user, String message, int unReadMessages) {
    socket.emit(SOCKET_ON.SEND_MESSAGE, {
      'roomID': roomID,
      'user': user.toJson(),
      'message': message,
      'unReadMessages': unReadMessages
    });
    print('message sent');
  }

  void leaveChat(String roomID) {
    isChatPageOpen = false;
    socket.emit(SOCKET_ON.LEAVE_CHAT, {"roomID": roomID});
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
