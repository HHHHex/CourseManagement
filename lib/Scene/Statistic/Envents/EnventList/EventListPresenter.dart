import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';
import 'package:boxing_lessons/Scene/Statistic/Envents/EnventList/EventItemModel.dart';
import 'package:boxing_lessons/Scene/Statistic/Envents/RemindEventModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:sqflite/sqflite.dart';

class EventListPresenter {

  RemindEventType _type;

  EventListPresenter(RemindEventType type) {
    _type = type;
  }

  List<EventItemModel> list = [];

  Future<void> fetchData() async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    List<Map> list = await db.rawQuery(
        'SELECT id FROM ${DataBaseManager.remind} WHERE type = ${_type.index}');
    List<EventItemModel> eventList = [];
    if (_type == RemindEventType.orderTimesLimit) {
      for (var i = 0; i < list.length; i++) {
        Map params = list[i];
        int id = params['id'];
        OrderModel order = await DataBaseManager.shared().fetchOrder(id, false);
        EventItemModel model = EventItemModel();
        model.title = order.member.name;
        model.detail = "剩余${order.remainTimes}节课";
        eventList.add(model);
      }
      this.list = eventList;
    } else if (_type == RemindEventType.orderExpireTime) {
      int now = DateTime.now().millisecondsSinceEpoch;
      for (var i = 0; i < list.length; i++) {
        Map params = list[i];
        int id = params['id'];
        OrderModel order = await DataBaseManager.shared().fetchOrder(id, false);
        int milliSeconds = order.expireTime - now;
        double day = milliSeconds * 0.001 / (60 * 60 * 24);
        EventItemModel model = EventItemModel();
        model.title = order.member.name;
        model.detail = "合同将于${day.toInt()}天后到期";
        eventList.add(model);
      }
      this.list = eventList;
    } else if (_type == RemindEventType.birthDay) {

    }
    db.close();
  }

}