import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';

abstract class MemberListProtocol {

  void reloadData();

  void onLoadErro(String msg);
}

class MemberListPresenter {

  List<MemberModel> models = [];

  MemberListProtocol attachView;

  MemberListPresenter(this.attachView) {}

  Future<void> fetchData(String string) async {
    String sql;
    if (string.length == 0) {
      sql = 'SELECT * FROM ${DataBaseManager.member}';
    } else {
      sql = 'SELECT * FROM ${DataBaseManager.member} WHERE member_name LIKE \'%${string}%\' LIMIT 10';
    }
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery(sql);
    await db.close();
    this.models = MemberModel.modesFromList(list);
    attachView.reloadData();
  }

}