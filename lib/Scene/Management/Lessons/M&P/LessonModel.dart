import 'package:boxing_lessons/General/Model/TableModel.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';

class LessonModel extends TableModel {

  int id = 0;

  String name = '';

  double duration = 1.0;

  double price = 300.0;

  int coachId = 0;

  CoachModel coach;

  int times = 6;

  String descript = '';

  int createTime;

  int modifyTime;

  LessonModel(){}

  LessonModel.withMap(Map map) {
    this.id = map['id'] ?? 0;
    this.name = map['lesson_name'] ?? '';
    this.duration = map['duration'] ?? 0;
    this.price = map['price'] ?? 0;
    this.coachId = map['coachId'] ?? 0;
    this.times = map['times'] ?? 0;
    this.descript = map['descript'] ?? '';
    this.createTime = map['create_time'] ?? 0;
    this.modifyTime = map['modify_time'] ?? 0;
  }

  static List<LessonModel> modesFromList(List<Map> list) {
    List<LessonModel> temp = [];
    list.forEach((map) {
      temp.add(LessonModel.withMap(map));
    });
    return temp;
  }

}
