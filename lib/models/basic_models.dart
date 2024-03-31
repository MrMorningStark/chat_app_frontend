import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/models/user_model.dart';

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;

  ApiResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] ?? [],
      message: json['message'] ?? "",
    );
  }
}

class Chat {
  final int type;
  int status;
  final String text;
  final int createdAt;
  final MyUser user;
  int unReadMessages = 0;

  Chat({
    required this.type,
    required this.status,
    required this.text,
    required this.createdAt,
    required this.user,
    this.unReadMessages = 0,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      type: json['type'] ?? MessageType.self,
      status: json['status'] ?? MessageStatus.sent,
      text: json['text'] ?? "",
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      user: MyUser.fromJson(json['user']),
      unReadMessages: json['unReadMessages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'status': status,
      'text': text,
      'createdAt': createdAt,
      'user': user.toJson(),
      'unReadMessages': unReadMessages,
    };
  }
}

class SocketService {
  final String Function(String userId1, String userId2) initiateChat;
  final void Function(
          String roomID, MyUser userID, String message, int unReadMessages)
      sendMessage;
  final void Function(String roomID) leaveChat;

  SocketService({
    required this.initiateChat,
    required this.sendMessage,
    required this.leaveChat,
  });
}
