import 'dart:convert';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:localstorage/localstorage.dart';

class DatabaseHelper {
  // final LocalStorage storage = initLocalStorage('WhatsApp');
  Future<dynamic> getValue(String key) async {
    try {
      return await jsonDecode(localStorage.getItem(key) ?? "false");
    } catch (e) {
      print("Error getting value: $e");
      return null;
    }
  }

  setValue(String key, Object value) {
    try {
      var stringValue = jsonEncode(value); // convert in encoded format
      localStorage.setItem(key, stringValue);
    } catch (e) {
      print("Error setting value: $e");
    }
  }

  deleteKey(String key) async {
    localStorage.removeItem(key);
  }

  deleteAllKeys() async {
    localStorage.clear();
  }

  Future<bool> isLoggedIn() async {
    return await getValue(LocalStorageKey.USER) ? true : false;
  }

  Future<MyUser?> getUser() async {
    var res = await getValue(LocalStorageKey.USER);
    if (res) {
      return MyUser.fromJson(res);
    }
    return null;
  }

  Future<void> saveRecentChats(List<MyUser> user) async {
    await setValue(LocalStorageKey.RECENT_CHATS, user);
  }

  Future<List<MyUser>> loadRecentChats() async {
    var res = await getValue(LocalStorageKey.RECENT_CHATS);
    if (res.runtimeType == bool) {
      return [];
    } else if (res != null) {
      List<MyUser> recentChats =
          List<MyUser>.from(res.map((e) => MyUser.fromJson(e)));
      return recentChats;
    } else {
      return [];
    }
  }

  Future<Chat?> getLastMessage(String roomID) async {
    try {
      var res = await getValue(roomID);
      if (res.runtimeType == bool) {
        return null;
      } else if (res != null) {
        List<Chat> chats = List<Chat>.from(res.map((e) => Chat.fromJson(e)));
        return chats[0];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveChat(String conversationId, List<Chat> message) async {
    await setValue(conversationId, message);
  }

  Future<List<Chat>> getChat(String key) async {
    var res = await getValue(key);
    if (res.runtimeType == bool) {
      return [];
    } else if (res != null) {
      List<Chat> chats = List<Chat>.from(res.map((e) => Chat.fromJson(e)));
      return chats;
    } else {
      return [];
    }
  }

  Future<void> updateChat(String conversationId, int status) async {
    var res = await getValue(conversationId);
    if (res.runtimeType == bool) {
      return;
    } else if (res != null) {
      List<Chat> chats =
          List<Chat>.from(res.map((e) => Chat.fromJson(e))).map((e) {
        if (e.status == MessageStatus.read) {
          return e;
        } else if (status == MessageStatus.delivered) {
          if (e.status == MessageStatus.sent) {
            e.status = status;
          }
        } else if (status == MessageStatus.read) {
          if (e.status == MessageStatus.delivered ||
              e.status == MessageStatus.sent) {
            e.status = status;
          }
        }
        e.status = status;
        return e;
      }).toList();
      await setValue(conversationId, chats);
    }
  }
}
