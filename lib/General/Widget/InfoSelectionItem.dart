import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum InfoSelectionItemType {
  none,
  page,
}

class InfoSelectionItem extends StatefulWidget {
  final bool isRequ;
  final InfoSelectionItemType type;
  final String info;
  final String detail;
  final VoidCallback onTap;

  InfoSelectionItem({
    Key key,
    this.isRequ,
    this.type = InfoSelectionItemType.none,
    this.info,
    this.detail,
    this.onTap,
  }) : super(key: key);

  @override
  _InfoSelectionItemState createState() => _InfoSelectionItemState();
}

class _InfoSelectionItemState extends State<InfoSelectionItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: 80,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
          child: Row(
            children: [
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(children: [
                          TextSpan(
                            text: '*  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: this.widget.isRequ
                                    ? Colors.redAccent
                                    : Colors.black12),
                          ),
                          TextSpan(
                            text: this.widget.info,
                            style: TextStyle(fontSize: 14, color: Colors.black45),
                          ),
                        ])),
                    Text(
                      this.widget.detail,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              _getRightIcon()
            ],
          )),
      onTap: this.widget.onTap,
    );
  }

  Widget _getRightIcon() {
    if (this.widget.type == InfoSelectionItemType.none) {
      return Container();
    } else if (this.widget.type == InfoSelectionItemType.page) {
      return new Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.black12,
      );
    }
  }
}
