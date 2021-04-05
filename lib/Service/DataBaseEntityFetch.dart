import 'package:boxing_lessons/Scene/Management/Engage/Model/EngageModel.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/M&P/LessonModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';
import 'package:sqflite/sqflite.dart';
import 'DataBaseManager.dart';

extension EntityFetchExtended on DataBaseManager {

  /// public
  Future<CoachModel> fetchCoach(int id, bool isEnd) async {
    Database db = await openDatabase(DataBaseManager
        .shared()
        .dbPath);
    List<Map> list = await db.rawQuery(
        'SELECT * FROM ${DataBaseManager.coach} WHERE id = ${id}');
    if (isEnd) {
      await db.close();
    }
    if (list.length > 0) {
      CoachModel coach = CoachModel
          .modesFromList(list)
          .first;
      return coach;
    } else {
      return null;
    }
  }

  Future<LessonModel> fetchLesson(int id, bool isEnd) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.lesson} WHERE id = ${id}');
    if (list.length > 0) {
      LessonModel lesson = LessonModel.modesFromList(list).first;
      lesson.coach = await fetchCoach(lesson.coachId, false);
      if (isEnd) {
        await db.close();
      }
      return lesson;
    } else {
      return null;
    }
  }

  Future<OrderModel> fetchOrder(int id, bool isEnd) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.order} WHERE id = ${id}');
    if (list.length > 0) {
      OrderModel order = OrderModel.modesFromList(list).first;
      order.coach = await fetchCoach(order.coachId, false);
      order.lesson = await fetchLesson(order.lessonId, false);
      order.member = await fetchMember(order.memberId, false);
      if (isEnd) {
        await db.close();
      }
      return order;
    } else {
      return null;
    }
  }

  Future<EngageModel> fetchEngage(int id) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.engage} WHERE id = ${id}');
    if (list.length > 0) {
      EngageModel engage = EngageModel.modesFromList(list).first;
      engage.coach = await fetchCoach(engage.coachId, false);
      engage.lesson = await fetchLesson(engage.lessonId, false);
      engage.member = await fetchMember(engage.memberId, false);
      await db.close();
      return engage;
    } else {
      return null;
    }
  }

  Future<List> fetchEngageAtDay(DateTime day) async {
    DateTime dayStart = DateTime(day.year, day.month, day.day);
    DateTime dayEnd = DateTime(day.year, day.month, day.day + 1);
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.engage} WHERE start_time BETWEEN ${dayStart.millisecondsSinceEpoch} AND ${dayEnd.millisecondsSinceEpoch}');
    List<EngageModel> models = EngageModel.modesFromList(list);
    for(var i = 0; i < models.length; i++) {
      EngageModel model = models[i];
      model.member = await fetchMember(model.memberId, false);
      model.coach = await fetchCoach(model.coachId, false);
      model.lesson = await fetchLesson(model.lessonId, false);
    }
    await db.close();
    return models;
  }

  /// private
  Future<MemberModel> fetchMember(int id, bool isEnd) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> members = await db.rawQuery('SELECT * FROM ${DataBaseManager.member} WHERE id = ${id}');
    List<Map> orders = await db.rawQuery('SELECT * FROM ${DataBaseManager.order} WHERE member_id = ${id}');
    if (isEnd) {
      await db.close();
    }
    if (members.length > 0) {
      MemberModel member = MemberModel.modesFromList(members).first;
      member.orders = OrderModel.modesFromList(orders) ?? [];
      return member;
    } else {
      return null;
    }
  }

}