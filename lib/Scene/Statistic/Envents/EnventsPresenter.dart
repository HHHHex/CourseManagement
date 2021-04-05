import 'package:boxing_lessons/Scene/Statistic/Envents/RemindEventModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';

class EnventsPresenter {
  // 合同次数到期提醒
  int orderTimesLimitCount = 0;

  // 合同过期提醒
  int orderExpireTimeCount = 0;

  // 会员生日提醒
  int membersBirthDayCount = 0;

  int _fetchTime = 0;

  Future<void> fetchData() async {
    _fetchTime = DateTime.now().millisecondsSinceEpoch;
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    await _updateOrderTimesLimitReminds(db);
    await _updateorderExpireTimeReminds(db);
    await _updatemembersBirthDayReminds(db);
    String sql = "DELETE FROM ${DataBaseManager.remind} WHERE update_time != ${this._fetchTime}";
    await db.rawDelete(sql);
    int total = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ${DataBaseManager.remind}'));
    int unread = RemindEventState.unRead.index;
    this.orderTimesLimitCount = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ${DataBaseManager.remind} WHERE type = ${RemindEventType.orderTimesLimit.index} AND state = ${unread}'));
    this.orderExpireTimeCount = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ${DataBaseManager.remind} WHERE type = ${RemindEventType.orderExpireTime.index} AND state = ${unread}'));
    this.membersBirthDayCount = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ${DataBaseManager.remind} WHERE type = ${RemindEventType.birthDay.index} AND state = ${unread}'));
    await db.close();
  }

  Future<void> _updateOrderTimesLimitReminds(Database db) async {
    List<Map> list = await db.rawQuery(
        'SELECT id FROM ${DataBaseManager.order} WHERE remain_times <= 6');
    await _updateByType(db, list, RemindEventType.orderTimesLimit.index);
  }

  Future<void> _updateorderExpireTimeReminds(Database db) async {
    int tenDaysAfter =
        DateTime.now().add(Duration(days: 10)).millisecondsSinceEpoch;
    List<Map> list = await db.rawQuery(
        'SELECT id FROM ${DataBaseManager.order} WHERE expire_time <= ${tenDaysAfter}');
    await _updateByType(db, list, RemindEventType.orderExpireTime.index);
  }

  Future<void> _updatemembersBirthDayReminds(Database db) async {
    int fifteenDayAfter =
        DateTime.now().add(Duration(days: 15)).millisecondsSinceEpoch;
    List<Map> list = await db.rawQuery(
        'SELECT id FROM ${DataBaseManager.member} WHERE birth_day < ${fifteenDayAfter}');
    await _updateByType(db, list, RemindEventType.birthDay.index);
  }

  Future<void> _updateByType(Database db, List<Map> results, int type) async {
    for (var i = 0; i < results.length; i++) {
      Map param = results[i];
      int id = param["id"];
      int count = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM ${DataBaseManager.remind} WHERE type = ${type} AND refer_id = ${id}'));
      if (count == 0) {
        String sql =
            "INSERT INTO ${DataBaseManager.remind}(refer_id, type, state, create_time, update_time) VALUES("
            "'${id}', ${type}, ${RemindEventState.unRead.index}, ${this._fetchTime}, ${this._fetchTime})";
        await db.transaction((txn) async {
          int id = await txn.rawInsert(sql);
        });
      } else {
        String engageSQL =
            "UPDATE ${DataBaseManager.remind} SET update_time = ? WHERE refer_id = ? AND type = ?";
        await db.rawUpdate(
            engageSQL, [this._fetchTime, id, type]);
      }
    }
  }

  //@end
}
