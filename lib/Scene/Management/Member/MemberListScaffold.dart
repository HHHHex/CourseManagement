import 'package:boxing_lessons/General/Widget/EmptyPage.dart';
import 'package:boxing_lessons/Scene/Management/Member/Presenter/MemberListPresenter.dart';
import 'package:boxing_lessons/Scene/Management/Member/Model/MemberModel.dart';
import 'package:boxing_lessons/Scene/Management/Member/MemberDetailScaffold.dart';
import 'package:flutter/material.dart';

enum MemberListType {
  scan,
  selection,
}

class MemberListScaffold extends StatefulWidget {

  MemberListType type = MemberListType.scan;

  MemberListScaffold();

  MemberListScaffold.selection() {
    this.type = MemberListType.selection;
  }

  @override
  State<StatefulWidget> createState() {
    return _MemberListScaffoldState();
  }
}

class _MemberListScaffoldState extends State<MemberListScaffold>
    implements MemberListProtocol {

  TextEditingController _editingController = new TextEditingController();

  FocusNode _focusNode = FocusNode();

  bool _searching = false;

  MemberListPresenter _presenter;

  void dispose() {
    super.dispose();
    //释放
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _presenter.fetchData(_editingController.text);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _searching = true;
        });
      } else {
        setState(() {
          _searching = false;
        });
        _presenter.fetchData(_editingController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _viewByListCount(),
      floatingActionButton: _getActionButton(),
    );
  }

  _MemberListScaffoldState() {
    _presenter = MemberListPresenter(this);
  }

  Widget _viewByListCount() {
    if (_presenter.models.length == 0) {
      return EmptyPage();
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _getItemAtIndex(index);
      },
      itemCount: _presenter.models.length,
    );
  }

  @override
  void onClickIndex(int index) {
    MemberModel model = _presenter.models[index];
    if (this.widget.type == MemberListType.scan) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MemberDetailScaffold.withId(model.id))).then((
          value) {
        _presenter.fetchData(_editingController.text);
      });
    } else if (this.widget.type == MemberListType.selection) {
      Navigator.pop(context, model);
    }
  }

  void onClickAdd(BuildContext context) {
    Navigator.of(context)
        .push(
        MaterialPageRoute(builder: (context) => MemberDetailScaffold.add()))
        .then((value) {
      _presenter.fetchData(_editingController.text);
    });
  }

  @override
  Widget _getItemAtIndex(int index) {
    MemberModel model = _presenter.models[index];
    return _listItem(Icons.person, model.name, model.descript, index);
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadData() {
    setState(() {
    });
  }

  Widget _getActionButton() {
    if (this.widget.type == MemberListType.scan) {
      return FloatingActionButton(
          onPressed: () {
            onClickAdd(context);
          },
          child: Icon(Icons.person_add_sharp));
    } else {
      return null;
    }
  }

  Widget _listItem(IconData icon, String title, String detail, int index) {
    return Container(
        child: GestureDetector(
          child: Container(
            height: 60,
            child: ListTile(
              leading: Icon(icon),
              title: Text(title),
              subtitle: Text(detail),
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
            ),
          ),
          onTap: () {
            onClickIndex(index);
          },
        )
    );
  }

  Widget _getAppBar() {
    return AppBar(
      titleSpacing: 15,
      title:
      Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        height: 38,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: EdgeInsets.all(0),
          child: TextField(
            controller: _editingController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: "会员名称搜索",
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      actions: _getActions(),
    );
  }

  List<Widget> _getActions() {
    if (_searching) {
      return [
        InkWell(
          child:
          Container(width: 50, height: 50,
            child: Center(child:
            Text("取消"),
            ),
          ),
          onTap: () {
            _focusNode.unfocus();
          },
        )
      ];
    } else {
      return [];
    }

  }

}