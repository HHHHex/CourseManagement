import 'package:boxing_lessons/Scene/Management/Member/Model/MemberDetailModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:sqflite/sqflite.dart';

abstract class MemberDetailProtocol {

  void reloadWithModel(MemberDetailModel detailModel);

  void onLoadErro(String msg);
}

class MemberDetailPresenter {
  MemberDetailProtocol attachView;

  MemberDetailPresenter(this.attachView) {}

  Future<void> fetchData(int id) async {
    MemberDetailModel detailModel = MemberDetailModel();
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    detailModel.member = await DataBaseManager.shared().fetchMember(id, false);
    detailModel.orderCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${DataBaseManager.order} WHERE member_id = ${id}'));
    print(detailModel.orderCount);
    detailModel.engageCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${DataBaseManager.engage} WHERE member_id = ${id}'));
    await db.close();
    attachView.reloadWithModel(detailModel);
  }

  Future<void> addMember(MemberModel member) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "INSERT INTO ${DataBaseManager.member}(member_name, gender, birth_day, contact, coach_id, descript, create_time, modify_time) VALUES("
        "'${member.name}',"
        "'${member.gender}',"
        "'${member.birthDay}',"
        "'${member.contact}',"
        "'${member.coachId}',"
        "'${member.descript}',"
        "'${member.createTime}',"
        "'${member.modifyTime}'"
        ")";
    await db.transaction((txn) async {
      int id = await txn.rawInsert(sql);
    });
    await db.close();
  }

  Future<void> updateMember(MemberModel member) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "UPDATE ${DataBaseManager.member} SET member_name = ?, gender = ?, birth_day = ?, contact = ?, coach_id = ?, descript = ?, modify_time = ? WHERE id = ?";
    int count = await db.rawUpdate(sql, [member.name, member.gender, member.birthDay, member.contact, member.coachId, member.descript, member.modifyTime, member.id]);
    await db.close();
  }

}