import 'package:WhatsApp/api/api.dart';
import 'package:WhatsApp/db/db.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var userProvider = StateProvider<MyUser?>((ref) {
  if (FirebaseAuth.instance.currentUser != null) {
    User userCredential = FirebaseAuth.instance.currentUser!;
    MyUser user = MyUser(
      uid: userCredential.uid,
      displayName: userCredential.displayName ?? '',
      email: userCredential.email ?? '',
      photoURL: userCredential.photoURL ?? '',
      phoneNumber: userCredential.phoneNumber ?? '',
    );
    return user;
  }
  return null;
});

final contactsPermissionProvider = StateProvider<bool>((ref) => true);

final currConversationID = StateProvider<String?>((ref) => null);

final futureLocalContactsProvider = FutureProvider<List<MyUser>>((ref) async {
  List<MyUser> localContacts = [];

  if (await FlutterContacts.requestPermission(readonly: true)) {
    ref.read(contactsPermissionProvider.notifier).state = true;
    final contacts = (await FlutterContacts.getContacts(withProperties: true))
        .map((e) => MyUser.fromContact(e))
        .toList();

    ApiResponse response = await API.usersExist(
        users: contacts.map((e) => e.toMyJson(myUser: e)).toList());
    if (response.success) {
      List<dynamic> resposeArray = response.data;
      localContacts = resposeArray.map((e) => MyUser.fromJson(e)).toList();
    }
  } else {
    ref.read(contactsPermissionProvider.notifier).state = false;
  }

  return localContacts;
});

// chatProvider with a mehod to add chat
final chatProvider = StateNotifierProvider<ChatNotifier, List<Chat>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<Chat>> {
  ChatNotifier() : super([]);

  void addChat(Chat chat) {
    state = [chat, ...state];
  }

  void changeChatStatus(String conversationId, int status) {
    if (state.isNotEmpty) {
      List<Chat> chats = state.map((e) {
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
      state = [...chats];
      // update in localstorage too
      DatabaseHelper().updateChat(conversationId, status);
    }
  }

  void setChat({required List<Chat> chats, String? conversationId}) {
    // save last 20 chat to local storage
    if (conversationId != null) {
      List<Chat> last20mssg = chats.take(20).toList();
      DatabaseHelper().saveChat(conversationId, last20mssg);
    }
    state = chats.toList();
  }

  void clearChat() {
    state = [];
  }
}

final recentChatProvider =
    StateNotifierProvider<RecentChatNotifier, List<MyUser>>((ref) {
  return RecentChatNotifier();
});

class RecentChatNotifier extends StateNotifier<List<MyUser>> {
  RecentChatNotifier() : super([]) {
    loadRecentChats();
  }

  loadRecentChats() async {
    state = await DatabaseHelper().loadRecentChats();
    ApiResponse response = await API.loadRecentChats();
    if (response.success) {
      List<MyUser> recentChats =
          List<MyUser>.from(response.data.map((e) => MyUser.fromJson(e)));
      DatabaseHelper().saveRecentChats(recentChats);
      state = recentChats;
    }
  }
}

final userChatProvider =
    StateNotifierProvider<UserChatNotifier, List<Chat>>((ref) {
  return UserChatNotifier();
});

class UserChatNotifier extends StateNotifier<List<Chat>> {
  UserChatNotifier() : super([]);

  addChat(Chat chat) async {
    state = [...state, chat];
  }
}
