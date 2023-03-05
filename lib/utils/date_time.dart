import 'package:intl/intl.dart';

class DateAndTime {
  static convertDate(
      {required String date,
      required String currentFormat,
      required String reqFormat}) {
    DateTime tempDate = DateFormat(currentFormat).parse(date);
    String formattedDate = DateFormat(reqFormat).format(tempDate);
    return formattedDate;
  }
}
