import 'package:boxing_lessons/General/Scaffold/TableDetailScaffold.dart';
import 'package:boxing_lessons/General/Widget/InfoSelectionItem.dart';
import 'package:boxing_lessons/General/Widget/InputTextDialog.dart';
import 'package:boxing_lessons/Scene/Management/Coach/CoachListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Scene/Management/Engage/View/EngageListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/LessonsCategoryScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/M&P/LessonModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/MemberListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderDetailPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:flutter/material.dart';
import 'package:boxing_lessons/Util/Convert.dart';

class OrderDetailScaffold extends TableDetailScaffold {

  OrderDetailScaffold.withId(int id): super.withId(id);
  OrderDetailScaffold.add() : super.add();

  @override
  TableDetailScaffoldState<TableDetailScaffold> getState() =>  _OrderDetailScaffoldState();
}

class _OrderDetailScaffoldState extends TableDetailScaffoldState<OrderDetailScaffold> implements OrderDetailProtocol {

  OrderModel _model;
  OrderModel _tempModel;
  OrderDetailPresenter _presenter;

  _OrderDetailScaffoldState() {
    _presenter = OrderDetailPresenter(this);
  }

  void initState() {
    super.initState();
    if (this.widget.type == TableDetailType.scan) {
      DataBaseManager.shared().fetchOrder(this.widget.id, true).then((model) {
        setState(() {
          _model = model;
        });
      });
    } else {
      _model = OrderModel();
    }
  }

  String getTitle() {
    String title = '';
    switch (this.widget.type) {
      case TableDetailType.scan:
        title = '合同详情';
        break;
      case TableDetailType.add:
        title = '新增合同';
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
          info:'会员',
          detail: _model.member.name,
          onTap: (){
            _onSelectMember(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'教练',
          detail: _model.coach.name,
          onTap: (){
            _onSelectCoach(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'课程',
          detail: _model.lesson.name,
          onTap: (){
            _onSelectLesson(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'总量',
          detail: '${_model.totalTimes} 节',
          onTap: (){
            _onSelectTotalTimes(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          type: _pageCellType(),
          info:'进度',
          detail: '${_model.remainTimes} / ${_model.totalTimes} 节',
          onTap: (){
            _onSelectRemianTimes(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'单价',
          detail: "￥${_model.siglePrice.toString()}",
          onTap: (){
            _onSelectPrice(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'实收 / 应收',
          detail: "实收：￥${_model.earning.toString()}  应收：￥${_model.totalPrice.toString()}",
          onTap: (){
            _onSelectEaring(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'到期时间',
          detail: DateTime.fromMillisecondsSinceEpoch(_model.expireTime).dayString(),
          onTap: (){
            _onselectExpireTime(context);
          }),
      InfoSelectionItem(
          isRequ: false,
          info:'备注',
          detail: '${_model.descript}',
          onTap: (){
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

  InfoSelectionItemType _pageCellType() {
    return this.widget.type == TableDetailType.scan ? InfoSelectionItemType.page : InfoSelectionItemType.none;
  }

  void onDidSubmit() {
    if (this.widget.type == TableDetailType.add) {
      _model.createTime = DateTime.now().millisecondsSinceEpoch;
      _model.modifyTime = DateTime.now().millisecondsSinceEpoch;
      _presenter.addOrder(_model);
      Navigator.pop(context);
    } else if (this.widget.type == TableDetailType.edit) {
      _model.modifyTime = DateTime.now().millisecondsSinceEpoch;
      _presenter.updateOrder(_model);
      setState(() {
        this.widget.type = TableDetailType.scan;
      });
    }
  }

  void _onSelectRemianTimes(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>EngageListScaffold.withMemberId(_model.memberId)));
    }
  }

  void _onSelectMember(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>MemberListScaffold.selection())).then((model){
      if (model is MemberModel) {
        MemberModel member = model;
        print(member.id);
        setState(() {
          _model.member = member;
          _model.memberId = member.id;
        });
      } else {
        // do noting
      }
    });
  }

  void _onSelectCoach(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CoachListScaffold.selection())).then((model){
      if (model is CoachModel) {
        CoachModel coach = model;
        setState(() {
          _model.coach = coach;
          _model.coachId = coach.id;
        });
      } else {
        // do noting
      }
    });
  }

  void _onSelectLesson(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>LessonsCategoryScaffold.selection())).then((model){
      if (model is LessonModel) {
        LessonModel lesson = model;
        setState(() {
          _model.lesson = lesson;
          _model.lessonId = lesson.id;
          _model.siglePrice = lesson.price;
          _model.earning = _model.totalPrice;
        });
      } else {
        // do noting
      }
    });
  }

  void _onSelectTotalTimes(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
              text: _model.totalTimes.toString(),
              keyBoardType: TextInputType.numberWithOptions(decimal: false),
              maxLenth: 2,
              onClickSubmit: (str) {
                setState(() {
                  _model.totalTimes = int.parse(str);
                  _model.remainTimes = _model.totalTimes;
                  _model.earning = _model.totalPrice;
                });
              },
            ),
          );
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
              text: _model.siglePrice.toString(),
              keyBoardType: TextInputType.numberWithOptions(decimal: true),
              maxLenth: 8,
              onClickSubmit: (str) {
                setState(() {
                  _model.siglePrice = double.parse(str);
                  _model.earning = _model.totalPrice;
                });
              },
            ),
          );
        });
  }

  void _onSelectEaring(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
              text: _model.earning.toString(),
              keyBoardType: TextInputType.numberWithOptions(decimal: true),
              maxLenth: 8,
              onClickSubmit: (str) {
                setState(() {
                  _model.earning = double.parse(str);
                });
              },
            ),
          );
        });
  }

  Future<void> _onselectExpireTime(BuildContext context) async {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    var datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(_model.expireTime),
      firstDate: DateTime(2019),
      lastDate: DateTime(2026),
      helpText: "选择约课时间",
    );
    if (datePicker == null) {
      return;
    }
    var selectDate = new DateTime(datePicker.year, datePicker.month, datePicker.day, 0, 0, 0);
    setState(() {
      _model.expireTime = selectDate.millisecondsSinceEpoch;
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
  void reloadWithOrder(OrderModel order) {
    setState(() {
      _model = order;
    });
  }

}