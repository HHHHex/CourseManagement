import 'package:boxing_lessons/General/Widget/InfoSelectionItem.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SummarizeModel {
  int memberCount = 0;

  int coachCount = 0;

  int orderCount = 0;

  int engageCount = 0;
}

class OrderSummarizeScaffold extends StatefulWidget {
  @override
  _OrderSummarizeScaffoldState createState() => _OrderSummarizeScaffoldState();
}

class _OrderSummarizeScaffoldState extends State<OrderSummarizeScaffold> {

  SummarizeModel _model = SummarizeModel();

  @override
  void initState() {
    super.initState();
    _queryNum().then((v) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('总览')),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          InfoSelectionItem(
              isRequ: false,
              info:'总单',
              detail: '${_model.orderCount}',
              ),
          InfoSelectionItem(
              isRequ: false,
              info:'约课数',
              detail: '${_model.engageCount}',
              ),
          InfoSelectionItem(
              isRequ: false,
              info:'会员人数',
              detail: '${_model.memberCount}',
              ),
          InfoSelectionItem(
              isRequ: false,
              info:'教练人数',
              detail: '${_model.coachCount}',
              ),
        ],
      ),
    );
  }
  Future<void> _queryNum() async {
    Database db = await openDatabase(DataBaseManager.shared().dbPath);
    _model.memberCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${DataBaseManager.member}'));
    _model.coachCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${DataBaseManager.coach}'));
    _model.orderCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${DataBaseManager.order}'));
    _model.engageCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${DataBaseManager.engage}'));
    await db.close();
  }

}