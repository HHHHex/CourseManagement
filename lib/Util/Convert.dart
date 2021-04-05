//import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

extension DateConvert on DateTime {

  String dayString() {
    return formatDate(this, [yyyy, '年', mm, '月', dd, '日']);
  }

  String dayHour() {
    return formatDate(this, [yyyy, '年', mm, '月', dd, am, hh, ':', mm]);
  }

  String sortHour() {
    return formatDate(this, [am, hh, ':', mm]);
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