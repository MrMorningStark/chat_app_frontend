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
    state = [...state, chat];
  }

  void clearChat() {
    state = [];
  }

  changeMessageStatus(String roomID, int status) async {
    List<Chat>? chats =
        await DatabaseHelper().changeMessageStatus(roomID, status);
    if (chats != null) {
      state = chats;
    }
  }

  loadChatFromLocalStorage(String key, MyUser user) async {
    state = await DatabaseHelper().loadChat(key, user);
  }

  saveChatToLocalStorage(String key, Chat message) async {
    Chat chat = await DatabaseHelper().saveChat(key, message);
    state = [chat, ...state];
  }
}

final recentChatProvider =
    StateNotifierProvider<RecentChatNotifier, List<MyUser>>((ref) {
  return RecentChatNotifier();
});

class RecentChatNotifier extends StateNotifier<List<MyUser>> {
  RecentChatNotifier() : super([]);

  refreshRecentChats(MyUser currUser) async {
    List<MyUser> recentChats = await DatabaseHelper().loadRecentChats(currUser);
    state = recentChats;
  }

}
