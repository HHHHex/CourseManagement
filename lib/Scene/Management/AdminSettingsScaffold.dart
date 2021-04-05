import 'package:boxing_lessons/Scene/Management/Coach/CoachListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Lessons/LessonsCategoryScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Member/MemberListScaffold.dart';
import 'package:boxing_lessons/Scene/Management/Order/OrderDetailScaffold.dart';
import 'package:flutter/material.dart';

class AdminSettingsScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          _adminListItem(Icons.book, '课类', '查看和添加课程类别', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonsCategoryScaffold()));
          }),
          _adminListItem(Icons.person_outline, '教练', '查看和添加教练', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoachListScaffold()));
          }),
          _adminListItem(Icons.person_sharp, '会员', '查看和添加会员', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemberListScaffold()));
          }),
          _adminListItem(Icons.sticky_note_2_sharp, '创建合同', '创建一个新的合同', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetailScaffold.add()));
          }),
        ],
      ),
    );
  }

  Widget _adminListItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
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