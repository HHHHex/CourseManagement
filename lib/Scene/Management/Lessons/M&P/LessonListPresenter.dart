import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';
import 'LessonModel.dart';

abstract class LessonListProtocol {

  void reloadWithLessons(List<LessonModel> lessons);

  void onLoadErro(String msg);
}

class LessonListPresenter {
  LessonListProtocol attachView;

  LessonListPresenter(this.attachView) {}

  Future<void> fetchData() async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.lesson}');
    await db.close();
    attachView.reloadWithLessons(LessonModel.modesFromList(list));
  }

}