import 'package:boxing_lessons/General/Scaffold/ListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Engage/Model/EngageModel.dart';
import 'package:boxing_lessons/Scene/Management/Engage/Presenter/EngageListPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Engage/View/EngageDetailScaffold.dart';
import 'package:flutter/material.dart';
import 'package:boxing_lessons/Util/Convert.dart';

class EngageListScaffold extends ListScaffold {

  EngageListScaffold();
  EngageListScaffold.withOrderId(int orderId) {
    _orderId = orderId;
  }
  EngageListScaffold.withMemberId(int memberId) {
    _memberId = memberId;
  }

  int _orderId;
  int _memberId;

  EngageListScaffold.selection():super.selection();

  @override
  ListScaffoldState<ListScaffold> getState() => _EngageListScaffoldState();
}

class _EngageListScaffoldState extends ListScaffoldState<EngageListScaffold>  implements EngageListProtocol {
  EngageListPresenter _presenter;

  _EngageListScaffoldState() {
    _presenter = EngageListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  String getTitle() {
    return "上课记录";
  }

  @override
  IconData getAddIcon() {
    return null;
  }

  void _fetchData() {
    if (this.widget._memberId != 0) {
      _presenter.fetchWithMemberId(this.widget._memberId);
    } else if (this.widget._orderId != 0) {
      _presenter.fetchWithOrderId(this.widget._orderId);
    }
  }

  @override
  void onClickIndex(int index) {
    EngageModel model = this.widget.list[index];
    if (this.widget.type == ListScaffoldType.scan) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EngageDetailScaffold.withId(model.id))).then((value){
        _fetchData();
      });
    } else if (this.widget.type == ListScaffoldType.selection) {
      Navigator.pop(context, model);
    }
  }

  void onClickAdd(BuildContext context) {
  }

  @override
  Widget getItemAtIndex(int index) {
    EngageModel model = this.widget.list[index];
    return listItem(Icons.sports_mma, DateTime.fromMillisecondsSinceEpoch(model.startTime).dayHour(), model.descript, index);
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reload() {
    setState(() {
      this.widget.list = _presenter.enages;
    });
  }

}