
import 'package:boxing_lessons/General/Widget/EmptyPage.dart';
import 'package:flutter/material.dart';

enum ListScaffoldType {
  scan,
  selection,
}

abstract class ListScaffold extends StatefulWidget {
  ListScaffoldType type = ListScaffoldType.scan;
  List list = [];

  ListScaffold();
  ListScaffold.selection() {
    this.type = ListScaffoldType.selection;
  }

  @override
  ListScaffoldState createState() => getState();

  ListScaffoldState getState();
}

abstract class ListScaffoldState<T extends ListScaffold> extends State<T> {

  Widget getItemAtIndex(int index) {
    return Container();
  }

  String getTitle() {
    return '';
  }

  IconData getAddIcon() {
    return Icons.add;
  }

  void onClickIndex(int index) {
  }

  void onClickAdd(BuildContext context) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text(getTitle())),
      body: _viewByListCount(),
      floatingActionButton: _getActionButton(),
    );
  }

  Widget _getActionButton() {
    IconData icon = getAddIcon();
    if (this.widget.type == ListScaffoldType.scan && icon != null) {
      return FloatingActionButton(
          onPressed: (){
            onClickAdd(context);
          },
          child: Icon(icon));
    } else {
      return null;
    }
  }

  Widget _viewByListCount() {
    if (this.widget.list.length == 0) {
      return EmptyPage();
    }
    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return getItemAtIndex(index);
      },
      itemCount: this.widget.list.length,
    );
  }

  Widget listItem(IconData icon, String title, String detail, int index) {
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
            onClickIndex(index);
          },
        )
    );
  }

}