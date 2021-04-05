import 'package:boxing_lessons/General/Model/TableModel.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/M&P/LessonModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';

class OrderModel extends TableModel {

  int memberId = 0;

  MemberModel member = MemberModel();

  int coachId = 0;

  CoachModel coach = CoachModel();

  int lessonId = 0;

  LessonModel lesson = LessonModel();

  double earning = 0.0;

  double siglePrice = 0.0;

  int expireTime = DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch;

  int totalTimes = 12;

  int remainTimes = 12;

  get totalPrice {
    return totalTimes * this.siglePrice;
  }

  OrderModel(){}

  OrderModel.withMap(Map map) {
    this.id = map['id'] ?? 0;
    this.descript = map['descript'] ?? '';
    this.coachId = map['coach_id'] ?? 0;
    this.memberId = map['member_id'] ?? 0;
    this.lessonId = map['lesson_id'] ?? 0;
    this.totalTimes = map['total_times'] ?? 0;
    this.remainTimes = map['remain_times'] ?? 0;
    this.expireTime = map['expire_time'] ?? 0;
    this.siglePrice = map['single_price'] ?? 0;
    this.earning = map['earning'] ?? 0.0;
    this.createTime = map['create_time'] ?? 0;
    this.modifyTime = map['modify_time'] ?? 0;
  }

  static List<OrderModel> modesFromList(List<Map> list) {
    List<OrderModel> temp = [];
    list.forEach((map) {
      temp.add(OrderModel.withMap(map));
    });
    return temp;
  }

}