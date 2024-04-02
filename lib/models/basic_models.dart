import 'package:WhatsApp/enumeration.dart';

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
  final String message;
  final int createdAt;
  final String createdBy;
  int status;

  Chat({
    required this.message,
    required this.createdAt,
    required this.createdBy,
    required this.status,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      message: json['message'] ?? "",
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      createdBy: json['createdBy'] ?? json['fromUID'],
      status: json['status'] ?? MessageStatus.sent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'status': status
    };
  }
}

class SocketService {
  final Future<void> Function(String toUser, String toUID) initiateChat;
  final void Function({required String toUID, required String message})
      sendMessage;
  final void Function(String toUID) leaveChat;

  SocketService({
    required this.initiateChat,
    required this.sendMessage,
    required this.leaveChat,
  });
}
