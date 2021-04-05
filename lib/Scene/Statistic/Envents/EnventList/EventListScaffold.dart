import 'package:boxing_lessons/General/Widget/EmptyPage.dart';
import 'package:boxing_lessons/Scene/Statistic/Envents/EnventList/EventItemModel.dart';
import 'package:boxing_lessons/Scene/Statistic/Envents/EnventList/EventListPresenter.dart';
import 'package:boxing_lessons/Scene/Statistic/Envents/RemindEventModel.dart';
import 'package:flutter/material.dart';

class EventListScaffold extends StatefulWidget {

  RemindEventType type;

  EventListScaffold({Key key, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EventListScaffold();
  }
}

class _EventListScaffold extends State<EventListScaffold> {

  EventListPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = EventListPresenter(this.widget.type);
    _presenter.fetchData().then((value) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text("事件列表")),
      body: _viewByListCount(),
    );
  }

  Widget _viewByListCount() {
    if (_presenter.list.length == 0) {
      return EmptyPage();
    }
    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return getItemAtIndex(index);
      },
      itemCount: _presenter.list.length,
    );
  }

  Widget getItemAtIndex(int index) {
    EventItemModel model = _presenter.list[index];
    return _listItem(Icons.notifications_active_outlined, model.title, model.detail, index);
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
                border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
            ),
          ),
          onTap: (){
            //onClickIndex(index);
          },
        )
    );
  }

}