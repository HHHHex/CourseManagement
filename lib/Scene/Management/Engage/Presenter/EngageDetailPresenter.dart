import 'package:boxing_lessons/Scene/Management/Engage/Model/EngageModel.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/M&P/LessonModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:sqflite/sqflite.dart';

abstract class EngageDetailProtocol {

  void reloadWithEngage();

  void onLoadErro(String msg);
}

class EngageDetailPresenter {

  EngageModel model;

  EngageDetailProtocol attachView;

  EngageDetailPresenter(this.attachView) {}

  Future<void> addEngage(EngageModel engage) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "INSERT INTO ${DataBaseManager.engage}(member_id, coach_id, lesson_id, order_id, start_time, duration, descript, create_time, modify_time, state) VALUES("
        "'${engage.memberId}',"
        "'${engage.coachId}',"
        "'${engage.lessonId}',"
        "'${engage.orderId}',"
        "'${engage.startTime}',"
        "'${engage.duration}',"
        "'${engage.descript}',"
        "'${engage.createTime}',"
        "'${engage.modifyTime}',"
        "'${engage.state.index}'"
        ")";
    await db.transaction((txn) async {
      int id = await txn.rawInsert(sql);
    });
    await db.close();
  }

  Future<void> setupByMember(MemberModel member) async {

    this.model.member = member;
    this.model.memberId = member.id;
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.order} WHERE member_id = ${this.model.memberId} AND order_type = 0 ORDER BY modify_time LIMIT 1');
    if (list.length != 0) {
      var order = OrderModel.modesFromList(list).first;
      this.model.order = order;
      this.model.orderId = order.id;
      LessonModel lesson = await DataBaseManager.shared().fetchLesson(order.lessonId, false);
      this.model.lesson = lesson;
      this.model.lessonId = lesson.id;
      CoachModel coach  = await DataBaseManager.shared().fetchCoach(order.coachId, false);
      this.model.coach = coach;
      this.model.coachId = coach.id;
      this.model.duration = lesson.duration;
    }
    await db.close();
    if (this.attachView != null) {
      this.attachView.reloadWithEngage();
    }
  }

  Future<void> setupByOrder(OrderModel order) async {
    this.model.order = order;
    this.model.orderId = order.id;
    print(this.model.orderId);
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    LessonModel lesson = await DataBaseManager.shared().fetchLesson(order.lessonId, false);
    this.model.lesson = lesson;
    this.model.lessonId = lesson.id;
    CoachModel coach  = await DataBaseManager.shared().fetchCoach(order.coachId, false);
    this.model.coach = coach;
    this.model.coachId = coach.id;
    this.model.duration = lesson.duration;
    await db.close();
    if (this.attachView != null) {
      this.attachView.reloadWithEngage();
    }
  }

  Future<void> completeEngage() async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String engageSQL =
        "UPDATE ${DataBaseManager.engage} SET state = ? WHERE id = ?";
    await db.rawUpdate(engageSQL, [this.model.state.index, this.model.id]);
    String orderSQL =
        "UPDATE ${DataBaseManager.order} SET remain_times = remain_times-1 WHERE id = ?";
    await db.rawUpdate(orderSQL, [this.model.orderId]);
    print(this.model.orderId);
    await db.close();
  }

  Future<void> cancelEngage() async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql = "DELETE FROM ${DataBaseManager.engage} WHERE id = ${this.model.id}";
    int count = await db.rawDelete(sql);
    await db.close();
  }

  Future<void> updateEngage(EngageModel engage) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "UPDATE ${DataBaseManager.engage} SET member_id = ?, coach_id = ?, lesson_id = ?, order_id, start_time = ?, duration = ?, descript = ?, modify_time = ? WHERE id = ?";
    int count = await db.rawUpdate(sql, [engage.memberId, engage.coachId, engage.lessonId, engage.orderId, engage.startTime, engage.duration, engage.descript, engage.modifyTime, engage.id]);
    await db.close();
  }

}