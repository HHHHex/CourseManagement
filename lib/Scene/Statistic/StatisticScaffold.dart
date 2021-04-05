import 'package:boxing_lessons/Scene/Management/Order/OrderSummarizeScaffold.dart';
import 'package:boxing_lessons/Scene/Statistic/Envents/EnventsScaffold.dart';
import 'package:flutter/material.dart';

class StatisticScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("统计"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          _ListItem(Icons.event, '事件', '近期将要发生的事务提醒', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnventsScaffold()));
          }),
          _ListItem(Icons.notes, '总览', '各项统计', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderSummarizeScaffold()));
          }),
        ],
      ),
    );
  }

  Widget _ListItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      child: Container(
        height: 60,
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
        ),
      ),
      onTap: onTap,
    );
  }

}