import 'package:boxing_lessons/General/Model/TableModel.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';

class MemberModel extends TableModel {

  int id = 0;

  String name = '';

  int gender = 1;

  int birthDay = DateTime(1990).millisecondsSinceEpoch;

  String contact = '';

  String descript = '';

  int coachId = 0;

  List<OrderModel> orders;

  int createTime;

  int modifyTime;

  MemberModel(){}

  MemberModel.withMap(Map map) {
    this.id = map['id'] ?? 0;
    this.name = map['member_name'] ?? '';
    this.gender = map['gender'] ?? 0;
    this.coachId = map['coach_id'] ?? 0;
    this.descript = map['descript'] ?? '';
    this.createTime = map['create_time'] ?? 0;
    this.modifyTime = map['modify_time'] ?? 0;
    this.birthDay = map['birth_day'] ?? 0;
    this.contact = map['contact'] ?? '';
  }

  static List<MemberModel> modesFromList(List<Map> list) {
    List<MemberModel> temp = [];
    list.forEach((map) {
      temp.add(MemberModel.withMap(map));
    });
    return temp;
  }
}