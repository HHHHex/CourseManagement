import 'package:boxing_lessons/Scene/Statistic/Envents/EnventList/EventListScaffold.dart';
import 'package:boxing_lessons/Scene/Statistic/Envents/EnventsPresenter.dart';
import 'package:boxing_lessons/Scene/Statistic/Envents/RemindEventModel.dart';
import 'package:flutter/material.dart';

class EnventsScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnventsScaffoldState();
  }
}

class _EnventsScaffoldState extends State<EnventsScaffold> {
  EnventsPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = EnventsPresenter();
    _presenter.fetchData().then((value) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("事件提醒")),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          _ListItem(Icons.event_busy, '合同到期提醒', '查看即将到期的合同',
              _presenter.orderExpireTimeCount, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventListScaffold())).then((value){
                  //_presenter.fetchData();
                });
              }),
          _ListItem(Icons.motion_photos_pause_outlined, '结课提醒', '查看次数即将消耗完的合同',
              _presenter.orderTimesLimitCount, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventListScaffold(type: RemindEventType.orderTimesLimit))).then((value){
                  //_presenter.fetchData();
                });
              }),
          _ListItem(Icons.cake_outlined, '会员生日提醒', '会员快过生日啦~',
              _presenter.membersBirthDayCount, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventListScaffold())).then((value){
                  //_presenter.fetchData();
                });
              }),
        ],
      ),
    );
  }

  Widget _ListItem(IconData icon, String title, String subtitle, int remind,
      VoidCallback onTap) {
    return GestureDetector(
      child: Container(
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand, //未定位widget占满Stack整个空间
          children: <Widget>[
            ListTile(
              leading: Icon(icon),
              title: Text(title),
              subtitle: Text(subtitle),
            ),
            Positioned(
              right: 16.0,
              width: 20,
              height: 20,
              child: _getRemindContainer(remind),
            ),
          ],
        ),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      ),
      onTap: onTap,
    );
  }

  Widget _getRemindContainer(int remind) {
    if (remind == 0) {
      return Container();
    } else {
      return Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Text(
          "${remind}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  @override
  void onLoadErro(String msg) {
    // TODO: implement onLoadErro
  }

  @override
  void reload() {
    // TODO: implement reload
  }
}
