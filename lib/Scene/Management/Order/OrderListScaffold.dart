import 'package:boxing_lessons/General/Scaffold/ListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Member/MemberDetailScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderListPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';
import 'package:boxing_lessons/Scene/Management/Order/OrderDetailScaffold.dart';
import 'package:flutter/material.dart';
import 'package:boxing_lessons/Util/Convert.dart';

class OrderListScaffold extends ListScaffold {

  int _memberId;

  OrderListScaffold();

  OrderListScaffold.selection():super.selection();

  OrderListScaffold.selectionByMember(int memberId) {
    this.type = ListScaffoldType.selection;
    this._memberId = memberId;
    print(_memberId);
  }

  OrderListScaffold.withMemberId(int id) {
    this._memberId = id;
  }

  @override
  ListScaffoldState<ListScaffold> getState() => _OrderListScaffoldState();
}

class _OrderListScaffoldState extends ListScaffoldState<OrderListScaffold>  implements OrderListProtocol {
  OrderListPresenter _presenter;

  _OrderListScaffoldState() {
    _presenter = OrderListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.fetchOrdersWithMemberId(widget._memberId);
  }

  @override
  String getTitle() {
    return "合同列表";
  }

  @override
  IconData getAddIcon() {
    return null;
  }

  @override
  void onClickIndex(int index) {
    OrderModel model = this.widget.list[index];
    if (this.widget.type == ListScaffoldType.scan) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetailScaffold.withId(model.id))).then((value){
        //_presenter.fetchData();
      });
    } else if (this.widget.type == ListScaffoldType.selection) {
      Navigator.pop(context, model);
    }
  }

  void onClickAdd(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemberDetailScaffold.add())).then((value){
      //_presenter.fetchData();
    });
  }

  @override
  Widget getItemAtIndex(int index) {
    OrderModel model = this.widget.list[index];
    if (model.type == OrderType.duration) {
      return listItem(
          Icons.sticky_note_2_sharp,
          "(${DateTime.fromMillisecondsSinceEpoch(model.createTime).dayString()})",
          "${DateTime.fromMillisecondsSinceEpoch(model.expireTime).dayString()}到期", index);
    } else {
      return listItem(
          Icons.sticky_note_2_sharp,
          "${model.lesson.name}(${DateTime.fromMillisecondsSinceEpoch(model.createTime).dayString()})",
          "${model.remainTimes} / ${model.totalTimes}", index);
    }
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadWithOrders(List<OrderModel> orders) {
    setState(() {
      this.widget.list = orders;
    });
  }

}