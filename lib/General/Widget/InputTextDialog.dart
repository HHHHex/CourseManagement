import 'package:flutter/material.dart';

class InputDialog extends AlertDialog {
  InputDialog({Widget contentWidget})
      : super(
          content: contentWidget,
          contentPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
}

double btnHeight = 60;
double borderWidth = 0.5;

class InputDialogContent extends StatefulWidget {
  String title;
  String text;
  TextInputType keyBoardType;
  int maxLenth;
  VoidCallback onClickCancel;
  Function(String) onClickSubmit;
  TextEditingController editingController = new TextEditingController();

  InputDialogContent(
      {this.title = "请输入",
      this.text = "",
      this.maxLenth = 10,
      this.keyBoardType = TextInputType.number,
      this.onClickCancel,
      this.onClickSubmit});

  @override
  _RenameDialogContentState createState() {
    this.editingController.text = this.text;
    return _RenameDialogContentState();
  }
}

class _RenameDialogContentState extends State<InputDialogContent> {
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        height: 200,
        width: 10000,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.grey),
                )),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                autofocus: true,
                keyboardType: this.widget.keyBoardType,
                maxLength: widget.maxLenth,
                style: TextStyle(color: Colors.black87),
                controller: widget.editingController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )),
              ),
            ),
            Container(
              // color: Colors.red,
              height: btnHeight,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Container(
                    // 按钮上面的横线
                    width: double.infinity,
                    color: Colors.blue,
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        onPressed: () {
                          widget.editingController.text = "";
                          if (widget.onClickCancel != null) {
                            widget.onClickCancel();
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "取消",
                          style: TextStyle(fontSize: 22, color: Colors.blue),
                        ),
                      ),
                      Container(
                        // 按钮中间的竖线
                        width: 1,
                        color: Colors.blue,
                        height: btnHeight - 2,
                      ),
                      FlatButton(
                          onPressed: () {
                            if (widget.onClickSubmit != null) {
                              widget.onClickSubmit(widget.editingController.text);
                            }
                            Navigator.of(context).pop();
                            widget.editingController.text = "";
                          },
                          child: Text(
                            "确认",
                            style: TextStyle(fontSize: 22, color: Colors.blue),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
