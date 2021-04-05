import 'package:boxing_lessons/General/Scaffold/ListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/LessonDetailScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/M&P/LessonListPresenter.dart';
import 'package:flutter/material.dart';
import 'M&P/LessonModel.dart';

class LessonsCategoryScaffold extends ListScaffold {
  LessonsCategoryScaffold();
  LessonsCategoryScaffold.selection():super.selection();

  @override
  ListScaffoldState<ListScaffold> getState() => _LessonsCategoryScaffoldState();
}

class _LessonsCategoryScaffoldState extends ListScaffoldState<LessonsCategoryScaffold> implements LessonListProtocol {
  LessonListPresenter _presenter;

  _LessonsCategoryScaffoldState() {
    _presenter = LessonListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.fetchData();
  }

  @override
  String getTitle() {
    return "课类列表";
  }

  @override
  IconData getAddIcon() {
    return Icons.note_add_sharp;
  }

  @override
  void onClickIndex(int index) {
    LessonModel model = this.widget.list[index];
    if (this.widget.type == ListScaffoldType.scan) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonDetailScaffold.withId(model.id))).then((value){
        _presenter.fetchData();
      });
    } else if (this.widget.type == ListScaffoldType.selection) {
      Navigator.pop(context, model);
    }
  }

  void onClickAdd(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonDetailScaffold.add())).then((value){
      _presenter.fetchData();
    });
  }

  @override
  Widget getItemAtIndex(int index) {
    LessonModel model = this.widget.list[index];
    return listItem(Icons.book_rounded, model.name, model.descript, index);
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reloadWithLessons(List<LessonModel> lessons) {
    // TODO: implement reloadWithLessons
    setState(() {
      this.widget.list = lessons;
      print(lessons);
    });
  }

}