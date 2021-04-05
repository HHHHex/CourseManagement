import 'package:boxing_lessons/General/Scaffold/ListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachListPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:flutter/material.dart';
import 'CoachDetailScaffold.dart';

class CoachListScaffold extends ListScaffold {

  CoachListScaffold();
  CoachListScaffold.selection():super.selection();

  @override
  ListScaffoldState<ListScaffold> getState() => _CoachListScaffoldState();
}

class _CoachListScaffoldState extends ListScaffoldState<CoachListScaffold> implements CoachListProtocol {
  CoachListPresenter _presenter;

  _CoachListScaffoldState() {
    _presenter = CoachListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.fetchData();
  }

  @override
  String getTitle() {
    return "教练列表";
  }

  @override
  IconData getAddIcon() {
    return Icons.person_add_outlined;
  }

  @override
  void onClickIndex(int index) {
    CoachModel model = this.widget.list[index];
    if (this.widget.type == ListScaffoldType.scan) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoachDetailScaffold.withId(model.id))).then((value){
        _presenter.fetchData();
      });
    } else if (this.widget.type == ListScaffoldType.selection) {
      Navigator.pop(context, model);
    }
  }

  void onClickAdd(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoachDetailScaffold.add())).then((value){
      _presenter.fetchData();
    });
  }

  @override
  Widget getItemAtIndex(int index) {
    CoachModel model = this.widget.list[index];
    return listItem(Icons.person_outline, model.name, model.descript, index);
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadWithCoaches(List<CoachModel> coaches) {
    setState(() {
      this.widget.list = coaches;
    });
  }

}