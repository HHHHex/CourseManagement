import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          '暂 \n无 \n数 \n据',
        style: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.black12,
          fontSize: 26,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

}