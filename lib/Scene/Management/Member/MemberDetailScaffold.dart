import 'package:boxing_lessons/General/Scaffold/TableDetailScaffold.dart';
import 'package:boxing_lessons/General/Widget/InfoSelectionItem.dart';
import 'package:boxing_lessons/General/Widget/InputTextDialog.dart';
import 'package:boxing_lessons/Scene/Management/Engage/View/EngageListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberDetailModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/Presenter/MemberDetailPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Scene/Management/Order/OrderListScaffold.dart';
import 'package:boxing_lessons/Util/Convert.dart';
import 'package:flutter/material.dart';

class MemberDetailScaffold extends TableDetailScaffold {

  MemberDetailScaffold.withId(int id): super.withId(id);
  MemberDetailScaffold.add() : super.add();

  @override
  TableDetailScaffoldState<TableDetailScaffold> getState() =>  _MemberDetailScaffoldState();
}

class _MemberDetailScaffoldState extends TableDetailScaffoldState<MemberDetailScaffold>  implements MemberDetailProtocol {

  MemberDetailModel _detailModel;
  MemberModel _memberModel;
  MemberDetailPresenter _presenter;

  _MemberDetailScaffoldState() {
    _presenter = MemberDetailPresenter(this);
  }

  void initState() {
    super.initState();
    if (this.widget.type == TableDetailType.scan) {
      _presenter.fetchData(this.widget.id);
    } else {
      _memberModel = MemberModel();
    }
  }

  String getTitle() {
    String title = '';
    switch (this.widget.type) {
      case TableDetailType.scan:
        title = '会员详情';
        break;
      case TableDetailType.add:
        title = '新增会员';
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
    if (_memberModel == null) {
      return [];
    }
    List<Widget> items = [
      InfoSelectionItem(
          isRequ: true,
          info:'姓名',
          detail: _memberModel.name,
          onTap: (){
            _onSelectName(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'联系方式',
          detail: _memberModel.contact,
          onTap: (){
            _onSelectContact(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'性别',
          detail: Convert.genderWithInt(_memberModel.gender),
          onTap: (){
            _onSelectGender(context);
          }),
      InfoSelectionItem(
          isRequ: true,
          info:'生日',
          detail: DateTime.fromMillisecondsSinceEpoch(_memberModel.birthDay).dayString(),
          onTap: (){
            _onSelectBirthday(context);
          }),
      InfoSelectionItem(
          isRequ: false,
          info:'备注',
          detail: '${_memberModel.descript}',
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
            type: _pageCellType(),
            info:'合同（份）',
            detail: '${_detailModel.orderCount}',
            onTap: (){
              _onSelectOrders(context);
            }),
        InfoSelectionItem(
            isRequ: false,
            type: _pageCellType(),
            info:'上课记录',
            detail: '${_detailModel.engageCount}',
            onTap: (){
              _onSelectLessons(context);
            }),
        InfoSelectionItem(
          isRequ: false,
          info: '创建时间',
          detail: DateTime.fromMillisecondsSinceEpoch(_memberModel.createTime).dayHour(),
        ),
        InfoSelectionItem(
          isRequ: false,
          info: '修改时间',
          detail: DateTime.fromMillisecondsSinceEpoch(_memberModel.modifyTime).dayHour(),
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
              text: _memberModel.name,
              keyBoardType: TextInputType.name,
              maxLenth: 6,
              onClickSubmit: (str) {
                setState(() {
                  _memberModel.name = str;
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
    // showInputTextDialog(context, _model.name, (str){
    //   setState(() {
    //     _model.name = str;
    //   });
    // });
  }

  Future<void> _onSelectBirthday(BuildContext context) async {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    var datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: "选择生日",
    );
    if (datePicker == null) {
      return;
    }
    var selectDate = new DateTime(datePicker.year, datePicker.month, datePicker.day, 0, 0, 0);
    setState(() {
      _memberModel.birthDay = selectDate.millisecondsSinceEpoch;
    });
  }

  void _onSelectContact(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return InputDialog(
            contentWidget: InputDialogContent(
              text: _memberModel.contact,
              keyBoardType: TextInputType.phone,
              maxLenth: 20,
              onClickSubmit: (str) {
                setState(() {
                  _memberModel.contact = str;
                });
              },
            ),
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
              text: _memberModel.descript,
              keyBoardType: TextInputType.text,
              maxLenth: 200,
              onClickSubmit: (str) {
                setState(() {
                  _memberModel.descript = str;
                });
              },
            ),
          );
        });
  }

  void _onSelectOrders(BuildContext context) {
    if (this.widget.type == TableDetailType.edit) {
      return;
    }
    var sf = OrderListScaffold.withMemberId(_memberModel.id);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>sf)).then((value){
    });
  }

  void _onSelectLessons(BuildContext context) {
    if (this.widget.type == TableDetailType.scan) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          EngageListScaffold.withMemberId(_memberModel.id)));
    }
  }

  InfoSelectionItemType _pageCellType() {
    return this.widget.type == TableDetailType.edit ? InfoSelectionItemType.none : InfoSelectionItemType.page;
  }

  void onDidSubmit() {
    MemberModel model = _memberModel;
    model.modifyTime = DateTime.now().millisecondsSinceEpoch;
    if (this.widget.type == TableDetailType.add) {
      model.createTime = DateTime.now().millisecondsSinceEpoch;
      _presenter.addMember(model);
    } else {
      _presenter.updateMember(model);
    }
    Navigator.pop(context);
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadWithModel(MemberDetailModel detailModel) {
    setState(() {
      _detailModel = detailModel;
      _memberModel = detailModel.member;
    });
  }

}