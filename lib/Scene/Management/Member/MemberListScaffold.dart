import 'package:boxing_lessons/General/Scaffold/ListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Member/Presenter/MemberListPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/MemberDetailScaffold.dart';
import 'package:flutter/material.dart';

class MemberListScaffold extends ListScaffold {

  MemberListScaffold();
  MemberListScaffold.selection():super.selection();

  @override
  ListScaffoldState<ListScaffold> getState() => _MemberListScaffoldState();
}

class _MemberListScaffoldState extends ListScaffoldState<MemberListScaffold>  implements MemberListProtocol {
  MemberListPresenter _presenter;

  _MemberListScaffoldState() {
    _presenter = MemberListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.fetchData();
  }

  @override
  String getTitle() {
    return "会员列表";
  }

  @override
  IconData getAddIcon() {
    return Icons.person_add_sharp;
  }

  @override
  void onClickIndex(int index) {
    MemberModel model = this.widget.list[index];
    if (this.widget.type == ListScaffoldType.scan) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemberDetailScaffold.withId(model.id))).then((value){
        _presenter.fetchData();
      });
    } else if (this.widget.type == ListScaffoldType.selection) {
      Navigator.pop(context, model);
    }
  }

  void onClickAdd(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemberDetailScaffold.add())).then((value){
      _presenter.fetchData();
    });
  }

  @override
  Widget getItemAtIndex(int index) {
    MemberModel model = this.widget.list[index];
    return listItem(Icons.person, model.name, model.descript, index);
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadWithMembers(List<MemberModel> members) {
    setState(() {
      this.widget.list = members;
    });
  }

}