import 'dart:convert';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:localstorage/localstorage.dart';

class DatabaseHelper {
  final LocalStorage storage = LocalStorage('WhatsApp');

  Future<dynamic> getValue(String key) async {
    try {
      await storage.ready;
      return await jsonDecode(await storage.getItem(key) ?? "false");
    } catch (e) {
      print("Error getting value: $e");
      return null;
    }
  }

  setValue(String key, Object value) async {
    try {
      await storage.ready;
      var stringValue = jsonEncode(value); // convert in encoded format
      await storage.setItem(key, stringValue);
    } catch (e) {
      print("Error setting value: $e");
    }
  }

  deleteKey(String key) async {
    await storage.ready;
    await storage.deleteItem(key);
  }

  deleteAllKeys() async {
    await storage.ready;
    await storage.clear();
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

  // Future<List<MyUser>> loadRecentChats(MyUser currUser) async {
  //   var res = await getValue(LocalStorageKey.RECENT_CHATS);
  //   if (res.runtimeType == bool) {
  //     return [];
  //   } else if (res != null) {
  //     List<MyUser> recentChats =
  //         List<MyUser>.from(res.map((e) => MyUser.fromJson(e)));
  //     for (var i = 0; i < recentChats.length; i++) {
  //       Chat? chat = await getLastMessage(
  //           generateRoomId(recentChats[i].uid, currUser.uid));
  //       recentChats[i].lastMessage = chat;
  //     }
  //     return recentChats;
  //   } else {
  //     return [];
  //   }
  // }

  Future<List<MyUser>> saveRecentChats(MyUser user) async {
    var res = await getValue(LocalStorageKey.RECENT_CHATS);
    if (res.runtimeType == bool) {
      await setValue(LocalStorageKey.RECENT_CHATS, [user]);
      return [];
    } else if (res != null) {
      List<MyUser> recentChats =
          List<MyUser>.from(res.map((e) => MyUser.fromJson(e)));
      int index = recentChats.indexWhere((element) => element.uid == user.uid);
      if (index != -1) {
        recentChats.removeAt(index);
        recentChats.insert(0, user);
      } else {
        recentChats.insert(0, user);
      }
      await setValue(LocalStorageKey.RECENT_CHATS,
          recentChats.map((e) => e.toJson()).toList());
      return recentChats;
    } else {
      await setValue(LocalStorageKey.RECENT_CHATS, [user]);
      return [];
    }
  }

  Future<List<Chat>> loadChat(String key, MyUser user) async {
    try {
      var res = await getValue(key);
      if (res.runtimeType == bool) {
        await saveRecentChats(user);
        return [];
      } else if (res != null) {
        List<Chat> chats = List<Chat>.from(res.map((e) => Chat.fromJson(e)));
        await setValue(key, chats);
        return chats;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Future<List<Chat>?> changeMessageStatus(String roomID, int status) async {
  //   try {
  //     await getValue(roomID);
  //     if (status == MessageStatus.sent) {
  //       return null;
  //     } else {
  //       var res = await getValue(roomID);
  //       if (res.runtimeType == bool) {
  //         return null;
  //       } else if (res != null) {
  //         List<Chat> chats = List<Chat>.from(res.map((e) => Chat.fromJson(e)));
  //         for (Chat chat in chats) {
  //           if (chat.status == MessageStatus.sent) {
  //             chat.status = status == MessageStatus.read
  //                 ? status
  //                 : MessageStatus.delivered;
  //           } else if (chat.status == MessageStatus.delivered) {
  //             chat.status = status == MessageStatus.read
  //                 ? status
  //                 : MessageStatus.delivered;
  //           } else {
  //             chat.status = MessageStatus.read;
  //           }
  //         }
  //         await setValue(roomID, chats);
  //         return chats;
  //       } else {
  //         return null;
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

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

  Future<Chat> saveChat(String key, Chat message) async {
    var res = await getValue(key);
    if (res.runtimeType == bool) {
      List<Chat> chats = [];
      chats.add(message);
      await setValue(key, chats.map((e) => e.toJson()).toList());
      return message;
    } else if (res != null) {
      List<Chat> chats = List<Chat>.from(res.map((e) => Chat.fromJson(e)));
      chats.insert(0, message);
      await setValue(key, chats.map((e) => e.toJson()).toList());
      return message;
    } else {
      List<Chat> chats = [];
      chats.add(message);
      await setValue(key, chats.map((e) => e.toJson()).toList());
      return message;
    }
  }
}
