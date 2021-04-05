import 'package:boxing_lessons/General/Widget/InfoSelectionItem.dart';
import 'package:boxing_lessons/General/Widget/InputTextDialog.dart';
import 'package:boxing_lessons/General/Widget/TimeStepperDialog.dart';
import 'package:boxing_lessons/Scene/Management/Engage/Presenter/EngageDetailPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Engage/Model/EngageModel.dart';
import 'package:boxing_lessons/Scene/Management/Coach/CoachListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Coach/M&P/CoachModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/MemberListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Order/M&P/OrderModel.dart';
import 'package:boxing_lessons/Scene/Management/Order/OrderListScaffold.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:flutter/material.dart';
import 'package:boxing_lessons/Util/Convert.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum EngageDetailType {
  scan,
  add,
}

class EngageDetailScaffold extends StatefulWidget {

  EngageDetailType type = EngageDetailType.add;

  int id = 0;

  EngageDetailScaffold.withId(int id) {
    this.type = EngageDetailType.scan;
    this.id = id;
  }

  EngageDetailScaffold.add() {
    this.type = EngageDetailType.add;
  }

  @override
  State<StatefulWidget> createState() {
    return _EngageDetailScaffoldState();
  }

}

class _EngageDetailScaffoldState extends State<EngageDetailScaffold> implements EngageDetailProtocol  {

  EngageDetailPresenter _presenter;

  _EngageDetailScaffoldState() {
    _presenter = EngageDetailPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title:Text(getTitle()),
          actions: _getBarActions(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: ListView(
            padding: EdgeInsets.all(10),
            children: getItems(),
          )),
          _getActions()
        ],
      ),
    );
  }

  void initState() {
    super.initState();
    if (this.widget.type == EngageDetailType.scan) {
      _presenter.model = EngageModel();
      DataBaseManager.shared().fetchEngage(this.widget.id).then((model) {
        setState(() {
          _presenter.model = model;
        });
      });
    } else {
      _presenter.model = EngageModel();
    }
  }

  String getTitle() {
    String title = '';
    switch (this.widget.type) {
      case EngageDetailType.scan:
        title = '约课详情';
        break;
      case EngageDetailType.add:
        title = '新增约课';
        break;
      default:
        break;
    }
    return title;
  }

  List<Widget> getItems() {
    var model = _presenter.model;
    if (model == null) {
      return [];
    }
    List<Widget> items = [
      InfoSelectionItem(
          isRequ: true,
          info:'会员',
          type: widget.type == EngageDetailType.scan ? InfoSelectionItemType.none : InfoSelectionItemType.page,
          detail: model.member.name,
          onTap: (){
            _onSelectMember();
          }),
      InfoSelectionItem(
          isRequ: true,
          info:widget.type == EngageDetailType.scan ? '课程' : '合同',
          detail: model.lesson.name,
          type: widget.type == EngageDetailType.scan ? InfoSelectionItemType.none : InfoSelectionItemType.page,
          onTap: (){
            _onSelectOrder();
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'教练',
          detail: model.coach.name,
          type: widget.type == EngageDetailType.scan ? InfoSelectionItemType.none : InfoSelectionItemType.page,
          onTap: (){
            _onSelectCoach();
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'开始时间',
          detail: DateTime.fromMillisecondsSinceEpoch(model.startTime).dayHour(),
          onTap: (){
            _onSelectAddDate();
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'课程时长',
          detail: '${model.duration} 小时',
          onTap: (){
            _onSelectTime(context);
          }),
      InfoSelectionItem(
          isRequ: false,
          info:'备注',
          detail: '${model.descript}',
          onTap: (){
            _onSelectDescript();
          }),
    ];
    if (this.widget.type == EngageDetailType.add) {
      return items;
    } else {
      List<Widget> scanItems = [
        InfoSelectionItem(
          isRequ: false,
          info: '创建时间',
          detail: DateTime.fromMillisecondsSinceEpoch(model.createTime).dayHour(),
        )
      ];
      return items..addAll(scanItems);
    }
  }

  List<Widget> _getBarActions() {
    if (this.widget.type == EngageDetailType.add) {
      return [
        IconButton(
            icon:Icon(Icons.save),
            onPressed: (){
              onDidSubmit();
            }),
      ];
    }  else {
      return [];
    }
  }

  Container _getActions() {
    if (this.widget.type == EngageDetailType.add) {
      return Container();
    } else {
      if (_presenter.model.state == EngageState.executing) {
        return Container(
          height: 60,
          padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextButton(
                  child: Text("完成课程", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 18, color: Colors.black45)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      //设置按下时的背景颜色
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue[200];
                      }
                      return Colors.green;
                    }),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    )),
                  ),
                  onPressed: () {
                    _onSelectCompleteEngage();
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text("取消约课", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 18)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      //设置按下时的背景颜色
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue[200];
                      }
                      return Colors.orangeAccent;
                    }),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    )),
                  ),
                  onPressed: () {
                    _onSelectIgnore();
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
            color: Colors.green,
            child: Center(
              child: Text("已完成",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            )
        );
      }
    }
  }

  void _onSelectMember() {
    if (this.widget.type == EngageDetailType.scan) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>MemberListScaffold.selection())).then((model){
      if (model is MemberModel) {
        MemberModel member = model;
        _presenter.setupByMember(member);
      } else {
        // do noting
      }
    });
  }

  void _onSelectOrder() {
    if (this.widget.type == EngageDetailType.scan) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OrderListScaffold.selectionByMember(_presenter.model.member.id))).then((model){
      if (model is OrderModel) {
        OrderModel order = model;
        _presenter.setupByOrder(order);
      } else {
        // do noting
      }
    });
  }

  void _onSelectCoach() {
    if (this.widget.type == EngageDetailType.scan) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CoachListScaffold.selection())).then((model){
      if (model is CoachModel) {
        CoachModel coach = model;
        setState(() {
          _presenter.model.coachId = coach.id;
          _presenter.model.coach = coach;
        });
      } else {
        // do noting
      }
    });
  }

  void _onSelectDescript() {
    if (this.widget.type == EngageDetailType.scan) {
      return;
    }
    var model = _presenter.model;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
              text: model.descript,
              keyBoardType: TextInputType.text,
              maxLenth: 200,
              onClickSubmit: (str) {
                setState(() {
                  model.descript = str;
                });
              },
            ),
          );
        });
  }

  void _onSelectAddDate() async {
    if (this.widget.type == EngageDetailType.scan) {
      return;
    }
    var datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2026),
      helpText: "选择约课时间",
    );
    if (datePicker == null) {
      return;
    }
    var timePicker =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (timePicker == null) {
      return;
    }
    var selectDate = new DateTime(datePicker.year, datePicker.month, datePicker.day, timePicker.hour, timePicker.minute, 0);
    setState(() {
      _presenter.model.startTime = selectDate.millisecondsSinceEpoch;
    });
  }

  void _onSelectTime(BuildContext context) {
    if (this.widget.type == EngageDetailType.scan) {
      return;
    }
    var model = _presenter.model;
    showTimeStepperDialog(context, model.duration, (val){
      setState(() {
        model.duration = val;
      });
    });
  }

  void onDidSubmit() {
    var model = _presenter.model;
    if (model.memberId == 0) {
      Fluttertoast.showToast(msg: "请选择必填项");
      return;
    }
    if (this.widget.type == EngageDetailType.add) {
      model.createTime = DateTime.now().millisecondsSinceEpoch;
      model.modifyTime = DateTime.now().millisecondsSinceEpoch;
      _presenter.addEngage(model);
      Navigator.pop(context);
    } else if (this.widget.type == EngageDetailType.scan) {
      model.modifyTime = DateTime.now().millisecondsSinceEpoch;
      _presenter.updateEngage(model);
      setState(() {
        this.widget.type = EngageDetailType.scan;
      });
    }
  }

  void _onSelectCompleteEngage() {
    _openAlertDialog("是否完成此次约课", () {
      _presenter.model.state = EngageState.complete;
      _presenter.completeEngage().then((vale) {
        Fluttertoast.showToast(msg: "课程状态已更新");
        setState(() {
        });
      });
    }, () {});
  }

  void _onSelectIgnore() {
    _openAlertDialog("是否取消本次约课", () {
      _presenter.cancelEngage().then((vale) {
        Fluttertoast.showToast(msg: "已取消本次约课");
        Navigator.pop(context);
      });
    }, () { });
  }

  Future _openAlertDialog(String text, VoidCallback submit, VoidCallback cancel) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false, //// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                cancel();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                submit();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadWithEngage() {
    setState(() {
      _presenter.model;
    });
  }

}


