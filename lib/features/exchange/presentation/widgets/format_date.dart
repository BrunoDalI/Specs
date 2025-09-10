import 'package:intl/intl.dart';

String formatDate(String? date) {
  if (date == null || date.isEmpty) return '';
  try {
    final parsedDate = DateTime.parse(date);
    final localDate = parsedDate.subtract(const Duration(hours: 3));
    final formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(localDate);

    return formattedDate.replaceFirst(':', 'h');
  } catch (e) {
    return '';
  }
}