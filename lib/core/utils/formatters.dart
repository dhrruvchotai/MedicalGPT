import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String formatChatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return DateFormat('h:mm a').format(dt);
    } else if (dt.year == now.year) {
      return DateFormat('MMM d, h:mm a').format(dt);
    } else {
      return DateFormat('MMM d yyyy').format(dt);
    }
  }

  static String formatJoinedDate(DateTime dt) {
    return DateFormat('MMMM yyyy').format(dt);
  }

  static String truncateMessage(String message, {int maxLength = 40}) {
    if (message.length <= maxLength) return message;
    return '${message.substring(0, maxLength)}...';
  }

  static String formatChatTitle(String firstMessage) {
    return truncateMessage(firstMessage, maxLength: 30);
  }
}
