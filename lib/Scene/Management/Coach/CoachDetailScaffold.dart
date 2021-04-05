import 'package:boxing_lessons/General/Scaffold/TableDetailScaffold.dart';
import 'package:boxing_lessons/General/Widget/InfoSelectionItem.dart';
import 'package:boxing_lessons/General/Widget/InputTextDialog.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:boxing_lessons/Util/Convert.dart';
import 'package:flutter/material.dart';
import 'M&P/CoachDetailPresenter.dart';

class CoachDetailScaffold extends TableDetailScaffold {
  CoachDetailScaffold.withId(int id) : super.withId(id);

  CoachDetailScaffold.add() : super.add();

  @override
  TableDetailScaffoldState<TableDetailScaffold> getState() =>
      _CoachDetailScaffoldState();
}

class _CoachDetailScaffoldState
    extends TableDetailScaffoldState<CoachDetailScaffold>
    implements CoachDetailProtocol {
  CoachModel _model;
  CoachModel _tempModel;
  CoachDetailPresenter _presenter;

  _CoachDetailScaffoldState() {
    _presenter = CoachDetailPresenter(this);
  }

  void initState() {
    super.initState();
    if (this.widget.type == TableDetailType.scan) {
      DataBaseManager.shared().fetchCoach(this.widget.id, true).then((model) {
        setState(() {
          _model = model;
        });
      });
    } else {
      _model = CoachModel();
    }
  }

  String getTitle() {
    String title = '';
    switch (this.widget.type) {
      case TableDetailType.scan:
        title = '教练详情';
        break;
      case TableDetailType.add:
        title = '新增教练';
        break;
      case TableDetailType.edit:
        title = '编辑';
        break;
      default:
        break;
    }
    return title;
  }

  List<Widget> getItems() {
    if (_model == null) {
      return [];
    }
    List<Widget> items = [
      InfoSelectionItem(
          isRequ: true,
          info: '姓名',
          detail: _model.name,
          onTap: () {
            _onSelectName(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info: '编号',
          detail: '${_model.number}',
          onTap: () {
            _onSelectNumber(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info: '性别',
          detail: Convert.genderWithInt(_model.gender),
          onTap: () {
            _onSelectGender(context);
          }),
      InfoSelectionItem(
          isRequ: false,
          info: '备注',
          detail: '${_model.descript}',
          onTap: () {
            _onSelectDescript(context);
          }),
    ];
    if (this.widget.type == TableDetailType.add ||
        this.widget.type == TableDetailType.edit) {
      return items;
    } else {
      List<Widget> scanItems = [
        InfoSelectionItem(
          isRequ: false,
          info: '创建时间',
          detail:
              DateTime.fromMillisecondsSinceEpoch(_model.createTime).dayHour(),
        ),
        InfoSelectionItem(
          isRequ: false,
          info: '修改时间',
          detail:
              DateTime.fromMillisecondsSinceEpoch(_model.modifyTime).dayHour(),
        ),
      ];
      return items..addAll(scanItems);
    }
  }

  void onDidSubmit() {
    _model.createTime = DateTime.now().millisecondsSinceEpoch;
    _model.modifyTime = DateTime.now().millisecondsSinceEpoch;
    _presenter.addCoach(_model);
    Navigator.pop(context);
  }

  void _onSelectName(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
              text: _model.name,
              keyBoardType: TextInputType.name,
              maxLenth: 6,
              onClickSubmit: (str) {
                setState(() {
                  _model.name = str;
                });
              },
            ),
          );
        });
  }

  void _onSelectNumber(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
              text: _model.number,
              keyBoardType: TextInputType.emailAddress,
              maxLenth: 20,
              onClickSubmit: (str) {
                setState(() {
                  _model.number = str;
                });
              },
            ),
          );
        });
  }

  void _onSelectGender(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
                title: "请输入描述",
                onClickSubmit: (str) {
                  _model.descript = str;
                }),
          );
        });
  }

  void _onSelectDescript(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
              text: _model.descript,
              keyBoardType: TextInputType.text,
              maxLenth: 200,
              onClickSubmit: (str) {
                setState(() {
                  _model.descript = str;
                });
              },
            ),
          );
        });
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadWithCoach(CoachModel coach) {
    setState(() {
      _model = coach;
    });
  }
}
