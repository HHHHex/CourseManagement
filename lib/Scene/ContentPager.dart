import 'package:boxing_lessons/Scene/Calendar/TodayPreviewScaffold.dart';
import 'package:boxing_lessons/Scene/Management/AdminSettingsScaffold.dart';
import 'package:boxing_lessons/Scene/Statistic/StatisticScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AppTabbar.dart';

class ContentPager extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;
  final ContentPagerEvent pagerEvent;

  const ContentPager({Key key, this.onIndexChanged, this.pagerEvent}) : super(key: key);

  @override
  _ContentPagerState createState() => _ContentPagerState();
}

class _ContentPagerState extends State<ContentPager> {
  PageController _pageController = PageController(
      viewportFraction: 1);

  @override
  void initState() {
    if (widget.pagerEvent != null) {
      widget.pagerEvent._pageController = _pageController;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // app bar
        Expanded(child: PageView( /**Expanded 撑开高度*/
          onPageChanged: widget.onIndexChanged,
          controller: _pageController,
          children: <Widget>[
            TodayPreviewScaffold(),
            AdminSettingsScaffold(),
            StatisticScaffold(),
            _createFoo(),
          ],
        ))
      ],
    );
  }

  Widget _createFoo() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo"),
      ),
      body: Center(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Text('点击'),
      ),
    );
  }

}

class ContentPagerEvent {
  PageController _pageController;
  void jumpToPage(int page) {
    // dart 编程技巧：安全的调用
    _pageController?.jumpToPage(page);
  }
}
