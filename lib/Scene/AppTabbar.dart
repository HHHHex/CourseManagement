import 'package:flutter/material.dart';
import 'ContentPager.dart';

class AppTabbar extends StatefulWidget {
  @override
  _AppTabbarState createState() => _AppTabbarState();
}

class _AppTabbarState extends State<AppTabbar> {

  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _curIndex = 0;
  final ContentPagerEvent _contentPagerEvent = ContentPagerEvent();

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 页面结构导航组件 Scaffold
      body: Container(
        // decoration 装饰器，用来描述组件样式的属性
        decoration: BoxDecoration( // 盒式装饰器
            gradient: LinearGradient(colors: [
              Color(0xffedeef0),
              Color(0xffe6e7e9),
            ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        child: ContentPager(
          pagerEvent: _contentPagerEvent,
          onIndexChanged: (int index){
            setState(() {
              _curIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar:
      BottomNavigationBar(
          currentIndex: _curIndex,
          onTap: (index){ // index: 回调传递参数
            // 控制内容滚动相应区域
            _contentPagerEvent.jumpToPage(index);
            setState(() {
              _curIndex = index;
            });
          } ,
          type: BottomNavigationBarType.fixed,
          items: [
            _bottomItem('Today', Icons.folder),
            _bottomItem('管理', Icons.explore),
            _bottomItem('统计', Icons.donut_small),
            _bottomItem('我的', Icons.person),
          ]
     ),
    );
  }

  _bottomItem(String title, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: _defaultColor,),
      activeIcon: Icon(icon, color: _activeColor,),
      label: title,
    );
  }

}