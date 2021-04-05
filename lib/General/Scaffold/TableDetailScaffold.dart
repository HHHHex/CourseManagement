import 'package:flutter/material.dart';

enum TableDetailType {
  scan,
  edit,
  add,
}

abstract class TableDetailScaffold extends StatefulWidget {

  TableDetailType type = TableDetailType.add;

  int id = 0;

  TableDetailScaffold.withId(int id) {
    this.type = TableDetailType.scan;
    this.id = id;
  }

  TableDetailScaffold.add() {
    this.type = TableDetailType.add;
  }

  @override
  TableDetailScaffoldState createState() => getState();

  TableDetailScaffoldState getState();
}

abstract class TableDetailScaffoldState<T extends TableDetailScaffold> extends State<T> {

  String getTitle() {
    return '';
  }

  List<Widget> getItems() {
    return [];
  }

  void onDidSubmit() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(getTitle()),
          actions: _getActions(),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: getItems(),
      ),
      floatingActionButton: _getActionButton(),
    );
  }

  List<Widget> _getActions() {
    if (this.widget.type == TableDetailType.add ||
        this.widget.type == TableDetailType.edit) {
      return [
        IconButton(
            icon:Icon(Icons.save),
            onPressed: (){
              _onClickSubmit();
            }),
      ];
    }  else {
      return [];
    }
  }

  Widget _getActionButton() {
    if (this.widget.type == TableDetailType.scan) {
      return FloatingActionButton(
          onPressed: (){
            _onClickEdit();
          },
          child: Text('编辑'),
          );
    } else if (this.widget.type == TableDetailType.edit) {
      return FloatingActionButton(
        onPressed: (){
          _onClickCancelEdit();
        },
        child: Text('恢复'),
      );
    } else {
      return null;
    }
  }

  void _onClickEdit() {
    setState(() {
      this.widget.type = TableDetailType.edit;
    });
  }

  void _onClickCancelEdit() {
    _openAlertDialog("是否放弃编辑？", () {
      setState(() {
        this.widget.type = TableDetailType.scan;
      });
    }, () {
    });
  }

  void _onClickSubmit() {
    _openAlertDialog("是否保存数据？", () {
      onDidSubmit();
    }, () {
    });
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

}