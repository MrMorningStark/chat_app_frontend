String generateRoomId(String userId1, String userId2) {
  // Concatenate user IDs and hash the result to generate a unique room ID
  final combinedIds = userId1.compareTo(userId2) < 0
      ? '$userId1-$userId2'
      : '$userId2-$userId1';
  return combinedIds.hashCode.toString();
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
  } else if (dateTime.day == DateTime.now().subtract(const Duration(days: 1))
      .day) {
    formattedDate = "Yesterday";
  } else {
    formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
  return formattedDate;
}