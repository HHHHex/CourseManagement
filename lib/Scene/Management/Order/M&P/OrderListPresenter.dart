import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:sqflite/sqflite.dart';

abstract class OrderListProtocol {

  void reloadWithOrders(List<OrderModel> members);

  void onLoadErro(String msg);
}

class OrderListPresenter {

  OrderListProtocol attachView;

  OrderListPresenter(this.attachView) {}

  Future<void> fetchOrdersWithMemberId(int memberId) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery('SELECT * FROM ${DataBaseManager.order} WHERE member_id = ${memberId}');
    List<OrderModel> orders = OrderModel.modesFromList(list);
    for(var i = 0; i < orders.length; i++) {
      OrderModel order = orders[i];
      order.lesson = await DataBaseManager.shared().fetchLesson(order.lessonId, false);
    }
    await db.close();
    attachView.reloadWithOrders(orders);
  }

}