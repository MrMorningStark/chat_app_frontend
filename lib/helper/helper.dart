String generateConversationId(String uid1, String uid2) {
  List<String> sortedIds = [uid1, uid2]..sort();
  String sortedIdsString = sortedIds.join('-');
  return sortedIdsString;
}

String formatDate(int millisecondsSinceEpoch) {
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  String formattedDate =
      "${hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  return formattedDate;
}

String formatDateForRecentChats(int millisecondsSinceEpoch) {
  // if message is sent today then show time and if yes then yesterday else date
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  String formattedDate = "";
  if (dateTime.day == DateTime.now().day) {
    formattedDate = formatDate(millisecondsSinceEpoch);
  } else if (dateTime.day ==
      DateTime.now().subtract(const Duration(days: 1)).day) {
    formattedDate = "Yesterday";
  } else {
    formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
  return formattedDate;
}
