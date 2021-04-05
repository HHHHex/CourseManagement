import 'package:boxing_lessons/General/Model/TableModel.dart';

class CoachModel extends TableModel {

  String name = '';

  String number = '';

  int gender = 1;

  CoachModel(){}

  CoachModel.withMap(Map map) {
    this.id = map['id'] ?? -1;
    this.name = map['coach_name'] ?? '';
    this.number = map['number'] ?? '';
    this.descript = map['descript'] ?? '';
    this.createTime = map['create_time'] ?? 0;
    this.modifyTime = map['modify_time'] ?? 0;
  }

  static List<CoachModel> modesFromList(List<Map> list) {
    List<CoachModel> temp = [];
    list.forEach((map) {
      temp.add(CoachModel.withMap(map));
    });
    return temp;
  }

}