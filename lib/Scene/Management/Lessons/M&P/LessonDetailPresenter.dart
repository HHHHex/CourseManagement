import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';
import 'LessonModel.dart';

abstract class LessonDetailProtocol {

  void reloadWithLesson(LessonModel lessons);

  void onLoadErro(String msg);
}

class LessonDetailPresenter {
  LessonDetailProtocol attachView;

  LessonDetailPresenter(this.attachView) {}

  Future<void> addLesson(LessonModel lesson) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "INSERT INTO ${DataBaseManager.lesson}(lesson_name, duration, price, coach_id, descript, create_time, modify_time) VALUES("
        "'${lesson.name}',"
        "'${lesson.duration}',"
        "'${lesson.price}',"
        "'${lesson.coachId}',"
        "'${lesson.descript}',"
        "'${lesson.createTime}',"
        "'${lesson.modifyTime}'"
        ")";
    await db.transaction((txn) async {
      int id = await txn.rawInsert(sql);
    });
    await db.close();
  }

  Future<void> updateLesson(LessonModel lesson) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "UPDATE ${DataBaseManager.lesson} SET lesson_name = ?, duration = ?, price = ?, coach_id = ?, descript = ?, modify_time = ? WHERE id = ?";
    int count = await db.rawUpdate(sql, [lesson.name, lesson.duration, lesson.price, lesson.coachId, lesson.descript, lesson.modifyTime, lesson.id]);
    await db.close();
  }

}