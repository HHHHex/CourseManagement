import 'package:boxing_lessons/General/Model/TableModel.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/M&P/LessonModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';

enum EngageState {
  // 进行中
  executing,//0
  // 已完成
  complete,//1
  // 已取消
  canceled,//2
}
class EngageModel extends TableModel {

  int coachId = 0;
  CoachModel coach = CoachModel();

  int memberId = 0;
  MemberModel member = MemberModel();

  int lessonId = 0;
  LessonModel lesson = LessonModel();

  int orderId = 0;
  OrderModel order = OrderModel();

  int startTime = DateTime.now().millisecondsSinceEpoch;

  double duration = 0.0;

  EngageState state = EngageState.executing;

  EngageModel(){}

  EngageModel.withMap(Map map) {
    this.id = map['id'] ?? -1;
    this.coachId = map['coach_id'] ?? 0;
    this.memberId = map['member_id'] ?? 0;
    this.lessonId = map['lesson_id'] ?? 0;
    this.orderId = map['order_id'] ?? 0;
    this.startTime = map['start_time'] ?? 0;
    this.duration = map['duration'] ?? 0.0;
    this.createTime = map['create_time'] ?? 0;
    this.modifyTime = map['modify_time'] ?? 0;
    var state =  map['state'] ?? 0;
    this.state = EngageState.values[state];
  }

  static List<EngageModel> modesFromList(List<Map> list) {
    List<EngageModel> temp = [];
    list.forEach((map) {
      temp.add(EngageModel.withMap(map));
    });
    return temp;
  }
}