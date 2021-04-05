import 'package:boxing_lessons/Scene/Management/Engage/Model/EngageModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';

abstract class EngageListProtocol {

  void reload();

  void onLoadErro(String msg);
}

class EngageListPresenter {

  List<EngageModel> enages = [];
  EngageListProtocol attachView;

  EngageListPresenter(this.attachView) {}

  Future<void> fetchWithMemberId(int memberId) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.engage} WHERE member_id = ${memberId}');
    await db.close();
    this.enages = EngageModel.modesFromList(list);
    attachView.reload();
  }

  Future<void> fetchWithOrderId(int orderId) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.engage} WHERE order_id = ${orderId}');
    await db.close();
    this.enages = EngageModel.modesFromList(list);
    attachView.reload();
  }

}