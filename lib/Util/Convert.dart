//import 'package:intl/intl.dart';

extension DateConvert on DateTime {

  String dayString() {
    return "";
    // var formatter = new DateFormat('yyyy年MM月dd日');
    // return formatter.format(this);
  }

  String dayHour() {
    return "";
    // var formatter = new DateFormat('yyyy年MM月dd日 a h:mm');
    // return formatter.format(this);
  }

  String sortHour() {
    return "";
    // var formatter = new DateFormat('a h:mm');
    // return formatter.format(this);
  }
}

class Convert {

  static String genderWithInt(int i){
    if (i == 0) {
      return '女';
    } else if (i == 1) {
      return '男';
    } else {
      return '未知';
    }
  }
}