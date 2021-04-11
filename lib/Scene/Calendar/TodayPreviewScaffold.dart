import 'package:boxing_lessons/General/Widget/EmptyPage.dart';
import 'package:boxing_lessons/Scene/Management/Engage/View/EngageDetailScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Engage/Model/EngageModel.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:boxing_lessons/Service/DataBaseEntityFetch.dart';
import 'package:flutter/material.dart';
import 'package:boxing_lessons/Util/Convert.dart';

class TodayPreviewScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodayPreviewScaffoldState();
}

class _TodayPreviewScaffoldState extends State<TodayPreviewScaffold> with AutomaticKeepAliveClientMixin<TodayPreviewScaffold> {

  @override
  bool get wantKeepAlive => true;

  List<EngageModel> _list = [];
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    DataBaseManager.shared().initialization().then((value){
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today"),
      ),
      body: Column(
        mainAxisAlignment : MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          _getSwitchWidget(),
          Expanded(
              child: _getListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _onSelectAddDate(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
  
  Widget _getSwitchWidget() {
    return Container(
      height: 44,
      child: Row(
        mainAxisAlignment : MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            child: IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: (){
                _onClickPrevious();
              },
            ),
          ),
          Expanded(
            child: Container(
              child: OutlinedButton(
                child: Text(_date.dayString()),
                onPressed: (){
                  _onClickSelectDay();
                },
              ),
            ),
          ),
          Container(
            width: 60,
            child: IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: (){
                _onClickNext();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getListView() {
    if (_list.length > 0) {
      return ListView.builder(
        itemBuilder:(BuildContext context, int index) {
          return _getItemAtIndex(index);
        },
        itemCount: _list.length,
      );
    } else {
      return EmptyPage();
    }
  }

  Widget _getItemAtIndex(int index) {
    EngageModel model = _list[index];
    var after = model.duration * 60 * 60 * 1000 + model.startTime;
    String dration = "由${DateTime.fromMillisecondsSinceEpoch(model.startTime).sortHour()}\n "
        "至${DateTime.fromMillisecondsSinceEpoch(after.toInt()).sortHour()}";
    String title = "${model.member.name}";
    String detail = "教练：${model.coach.name} 课程：${model.lesson.name}";
    return Container(
        child: GestureDetector(
          child: Container(
            height: 60,
            child: ListTile(
              leading: Text(dration),
              title: Text(title),
              subtitle: Text(detail),
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
            ),
          ),
          onTap: (){
            _onClickIndex(index);
          },
        )
    );
  }

  Future<void> _onClickSelectDay() async {
    var datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2026),
      helpText: "选择约课时间",
    );
    if (datePicker == null) {
      return;
    }
    var selectDate = new DateTime(datePicker.year, datePicker.month, datePicker.day, 1, 0, 0);
    _date = selectDate;
    _fetchData();
  }

  void _fetchData() {
    DataBaseManager.shared().fetchEngageAtDay(_date).then((models) {
      setState(() {
        _list = models;
      });
    });
  }

  void _onClickPrevious() {
    _date = _date.subtract(Duration(days: 1));
    _fetchData();
  }

  void _onClickNext() {
    _date = _date.add(Duration(days: 1));
    _fetchData();
  }

  void _onClickIndex(int index) {
    EngageModel model = _list[index];
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EngageDetailScaffold.withId(model.id))).then((value){
      _fetchData();
    });
  }

  void _onSelectAddDate(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EngageDetailScaffold.add())).then((value) {
      _fetchData();
    });
  }

}