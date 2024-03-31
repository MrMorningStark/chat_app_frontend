import 'package:WhatsApp/models/basic_models.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MyUser {
  final String uid;
  final String displayName;
  final String email;
  final String photoURL;
  final String? phoneNumber;
  Chat? lastMessage;
  bool isUserExist = true;

  MyUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.phoneNumber,
    this.lastMessage,
    this.isUserExist = true,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      uid: json['uid'],
      displayName: json['displayName'],
      email: json['email'],
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
      lastMessage: json['lastMessage'] != null
          ? Chat.fromJson(json['lastMessage'])
          : null,
      isUserExist: json['isUserExist'] ?? true,
    );
  }

  factory MyUser.fromContact(Contact contact) {
    return MyUser(
      uid: contact.id,
      displayName: contact.displayName,
      email: contact.emails.isNotEmpty ? contact.emails.first.address : '',
      photoURL: '',
      phoneNumber: contact.phones.isNotEmpty
          ? contact.phones.first.normalizedNumber
          : '',
      lastMessage: null,
      isUserExist: false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'lastMessage': lastMessage,
    };
  }

  Map<String, dynamic> toMyJson({required MyUser myUser}) {
    return {
      'uid': myUser.uid,
      'displayName': myUser.displayName,
      'email': myUser.email,
      'photoURL': myUser.photoURL,
      'phoneNumber': myUser.phoneNumber,
    };
  }
}
