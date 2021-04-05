import 'dart:ffi';

import 'package:boxing_lessons/General/Scaffold/TableDetailScaffold.dart';
import 'package:boxing_lessons/General/Widget/InfoSelectionItem.dart';
import 'package:boxing_lessons/General/Widget/InputTextDialog.dart';
import 'package:boxing_lessons/General/Widget/TimeStepperDialog.dart';
import 'package:boxing_lessons/Scene/Management/Coach/CoachListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/M&P/LessonDetailPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/M&P/LessonModel.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:flutter/material.dart';
import 'package:boxing_lessons/Util/Convert.dart';

class LessonDetailScaffold extends TableDetailScaffold {

  LessonDetailScaffold.withId(int id): super.withId(id);
  LessonDetailScaffold.add() : super.add();

  @override
  TableDetailScaffoldState<TableDetailScaffold> getState() =>  _LessonDetailScaffoldState();
}

class _LessonDetailScaffoldState extends TableDetailScaffoldState<LessonDetailScaffold> implements LessonDetailProtocol {
  LessonModel _model;
  LessonModel _tempModel;
  LessonDetailPresenter _presenter;

  _LessonDetailScaffoldState() {
    _presenter = LessonDetailPresenter(this);
  }

  void initState() {
    super.initState();
    if (this.widget.type == TableDetailType.scan) {
      DataBaseManager.shared().fetchLesson(this.widget.id, true).then((model) {
        setState(() {
          _model = model;
        });
      });
    } else {
      _model = LessonModel();
    }
  }

  String getTitle() {
    String title = '';
    switch (this.widget.type) {
      case TableDetailType.scan:
        title = '课类详情';
        break;
      case TableDetailType.add:
        title = '新增课类';
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
    String coachName = _model.coach != null ? _model.coach.name : '暂无';
    List<Widget> items = [
      InfoSelectionItem(
          isRequ: true,
          info:'课程名称',
          detail: _model.name,
          onTap: (){
            _onSelectName(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'每节时长（每节）',
          detail: '${_model.duration} 小时',
          onTap: (){
            _onSelectTime(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'建议零售价',
          detail: '￥ ${_model.price}',
          onTap: (){
            _onSelectPrice(context);
          }),
      InfoSelectionItem(
          isRequ: false,
          info:'默认教练',
          detail: coachName,
          onTap: (){
            _onSelectCoach(context);
          }),
      InfoSelectionItem(
          isRequ: false,
          info:'备注',
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
          detail: DateTime.fromMillisecondsSinceEpoch(_model.createTime).dayHour(),
        ),
        InfoSelectionItem(
          isRequ: false,
          info: '修改时间',
          detail: DateTime.fromMillisecondsSinceEpoch(_model.modifyTime).dayHour(),
        ),
      ];
      return items..addAll(scanItems);
    }
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
              maxLenth: 20,
              onClickSubmit: (str) {
                setState(() {
                  _model.name = str;
                });
              },
            ),
          );
        });
  }

  void _onSelectTime(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showTimeStepperDialog(context, _model.duration, (val){
      setState(() {
        _model.duration = val;
      });
    });
  }

  void _onSelectPrice(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
              text: _model.price.toString(),
              keyBoardType: TextInputType.numberWithOptions(decimal: true),
              maxLenth: 6,
              onClickSubmit: (str) {
                setState(() {
                  _model.price = double.parse(str);
                });
              },
            ),
          );
        });
  }

  void _onSelectCoach(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CoachListScaffold.selection())).then((model){
      if (model is CoachModel) {
        CoachModel coach = model;
        setState(() {
          _model.coachId = coach.id;
          _model.coach = coach;
        });
      } else {
        // do noting
      }
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

  void onDidSubmit() {
    if (this.widget.type == TableDetailType.add) {
      _model.createTime = DateTime.now().millisecondsSinceEpoch;
      _model.modifyTime = DateTime.now().millisecondsSinceEpoch;
      _presenter.addLesson(_model);
      Navigator.pop(context);
    } else if (this.widget.type == TableDetailType.edit) {
      _model.modifyTime = DateTime.now().millisecondsSinceEpoch;
      _presenter.updateLesson(_model);
      setState(() {
        this.widget.type = TableDetailType.scan;
      });
    }
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadWithLesson(LessonModel lessons) {
    setState(() {
      _model = lessons;
    });
  }

}