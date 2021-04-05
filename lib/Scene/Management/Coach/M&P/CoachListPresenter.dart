import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';

abstract class CoachListProtocol {

  void reloadWithCoaches(List<CoachModel> coaches);

  void onLoadErro(String msg);
}

class CoachListPresenter {
  CoachListProtocol attachView;

  CoachListPresenter(this.attachView) {}

  Future<void> fetchData() async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.coach}');
    await db.close();
    attachView.reloadWithCoaches(CoachModel.modesFromList(list));
  }

}