import 'package:WhatsApp/pages/contacts_page.dart';
import 'package:WhatsApp/constant.dart';
import 'package:WhatsApp/pages/home_page.dart';
import 'package:WhatsApp/pages/login_page.dart';
import 'package:WhatsApp/pages/search_page.dart';
import 'package:WhatsApp/pages/welcome_page.dart';
import 'package:flutter/material.dart';

class CollectionName {
  static const String USERS = "users";
}

class LocalStorageKey {
  static const String USER = "user";
  static const String RECENT_CHATS = "recentChats";
}

class NavigateType {
  static const int PUSH = 0;
  static const int REPLACE = 1;
  static const int POP = 2;
}

class MessageType {
  static const int self = 0;
  static const int other = 1;
}

class MessageStatus {
  static const int sent = 0;
  static const int delivered = 1;
  static const int read = 2;
}

class SOCKET_ON {
  static const String INITIATE_CHAT = "initiateChat";
  static const String LEAVE_CHAT = "leaveChat";
  static const String SEND_MESSAGE = "sendMessage";
  static const String USER_STATUS = "userStatus";
  static const String MESSAGE_STATUS = "messageStatus";
}

class Routes {
  static const String WELCOME_PAGE = "/welcome";
  static const String LOGIN_PAGE = "/login";
  static const String HOME_PAGE = "/home";
  static const String CONTACTS_PAGE = "/contacts";
  static const String SEARCH_PAGE = "/search";
  static const String CHAT_PAGE = "/chat";

  // return routes
  static getRoutes({required BuildContext context}) {
    return {
      WELCOME_PAGE: (context) => const WelcomePage(),
      HOME_PAGE: (context) => const HomePage(),
      LOGIN_PAGE: (context) => const LoginPage(),
      CONTACTS_PAGE: (context) => const ContactsPage(),
      SEARCH_PAGE: (context) => const SearchPage(),
    };
  }

  static navigateTo(
      {required String route,
      int naviagteType = NavigateType.PUSH,
      dynamic data}) {
    switch (naviagteType) {
      case NavigateType.PUSH:
        navigatorKey.currentState!.pushNamed(route, arguments: data);
        break;
      case NavigateType.REPLACE:
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil(route, (route) => false);
        break;
      case NavigateType.POP:
        navigatorKey.currentState!.pop();
        break;
      default:
        navigatorKey.currentState!.pushNamed(route);
        break;
    }
  }
}
