import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';

abstract class CoachDetailProtocol {

  void reloadWithCoach(CoachModel coach);

  void onLoadErro(String msg);
}

class CoachDetailPresenter {
  CoachDetailProtocol attachView;

  CoachDetailPresenter(this.attachView) {}

  Future<void> addCoach(CoachModel coach) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "INSERT INTO ${DataBaseManager.coach}(coach_name, number, gender, descript, create_time, modify_time) VALUES("
        "'${coach.name}',"
        "'${coach.number}',"
        "'${coach.gender}',"
        "'${coach.descript}',"
        "'${coach.createTime}',"
        "'${coach.modifyTime}'"
        ")";
    await db.transaction((txn) async {
      int id = await txn.rawInsert(sql);
    });
    await db.close();
  }

}