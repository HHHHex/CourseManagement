import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';

abstract class MemberListProtocol {

  void reloadWithMembers(List<MemberModel> members);

  void onLoadErro(String msg);
}

class MemberListPresenter {
  MemberListProtocol attachView;


  MemberListPresenter(this.attachView) {}

  Future<void> fetchData() async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.member}');
    await db.close();

    attachView.reloadWithMembers(MemberModel.modesFromList(list));
  }

}