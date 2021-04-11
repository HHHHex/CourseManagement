import 'package:flutter/material.dart';

void showItemSelectDialog(
    BuildContext context, List<String> items, Function(int val) onSelectIndex) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) =>
          ItemSelectDialog(items: items, onSelectIndex: onSelectIndex));
}

class ItemSelectDialog extends StatelessWidget {
  List<String> items = [];

  Function(int val) onSelectIndex;

  ItemSelectDialog({
    Key key,
    this.items,
    this.onSelectIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: this.items.length * 48.0,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        child: Text(
                          this.items[index],
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom:
                                BorderSide(width: 1, color: Colors.black12))),
                      ),
                      onTap: () {
                        if (onSelectIndex != null) {
                          onSelectIndex(index);
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                  itemCount: this.items.length,
                ),
              ),
              Container(
                height: 3,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  child: Text("取消", style: TextStyle(color: Colors.redAccent)),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 18, color: Colors.black45)),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      //设置按下时的背景颜色
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue[200];
                      }
                      return Colors.white;
                    }),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    )),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
