import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:sqflite/sqflite.dart';

abstract class OrderDetailProtocol {

  void reloadWithOrder(OrderModel order);

  void onLoadErro(String msg);
}

class OrderDetailPresenter {
  OrderDetailProtocol attachView;

  OrderDetailPresenter(this.attachView) {}

  Future<void> addOrder(OrderModel order) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "INSERT INTO ${DataBaseManager.order}(order_type, member_id, coach_id, lesson_id, total_times, remain_times, descript, create_time, modify_time, single_price, earning, expire_time) VALUES("
        "'${order.type.index}',"
        "'${order.memberId}',"
        "'${order.coachId}',"
        "'${order.lessonId}',"
        "'${order.totalTimes}',"
        "'${order.remainTimes}',"
        "'${order.descript}',"
        "'${order.createTime}',"
        "'${order.modifyTime}',"
        "'${order.siglePrice}',"
        "'${order.earning}',"
        "'${order.expireTime}'"
        ")";
    await db.transaction((txn) async {
      int id = await txn.rawInsert(sql);
    });
    await db.close();
  }

  Future<void> updateOrder(OrderModel order) async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    String sql =
        "UPDATE ${DataBaseManager.order} SET member_id = ?, coach_id = ?, lesson_id = ?, total_times = ?, remain_times = ?, descript = ?, modify_time = ? WHERE id = ?";
    int count = await db.rawUpdate(sql, [order.memberId, order.coachId, order.lessonId, order.totalTimes, order.remainTimes, order.descript, order.modifyTime, order.id]);
    await db.close();
  }

}