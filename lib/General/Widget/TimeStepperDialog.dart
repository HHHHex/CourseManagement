import 'package:flutter/material.dart';

void showTimeStepperDialog(BuildContext context, double value,Function(double val) onSubmit) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
          child: TimeStepperDialog(value: value, onSubmit: onSubmit)
      ));
}

class TimeStepperDialog extends StatefulWidget {

  double value = 1.0;
  Function(double val) onSubmit;

  TimeStepperDialog({
    Key key,
    this.value,
    this.onSubmit,
  }): super(key: key);

  @override
  _TimeStepperDialogState createState() => _TimeStepperDialogState();
}

class _TimeStepperDialogState extends State<TimeStepperDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 300,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Column(
        children: [
          Container(
              height: 30,
              child: Text(
                '请输入',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black26,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )),
          Container(
            height: 70,
            child: Row(
              mainAxisAlignment : MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlinedButton(
                  child: Text("-0.5"),
                  onPressed: (){
                    setState(() {
                      var value = this.widget.value - 0.5;
                      if (value > 0) {
                        this.widget.value = value;
                      }
                    });
                  },
                ),
                Text(
                  '${this.widget.value} 小时',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                OutlineButton(
                  child: Text("+0.5"),
                  onPressed: (){
                    setState(() {
                      this.widget.value += 0.5;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
              height: 44,
              child: Row(
                mainAxisAlignment : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlatButton(
                      textColor: Colors.blueAccent,
                      child: Text('确定'),
                      onPressed: (){
                        this.widget.onSubmit(this.widget.value);
                        Navigator.of(context).pop();
                      }),
                  FlatButton(
                      textColor: Colors.grey,
                      child: Text('取消'),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }),
                ],
              )
          ),
        ],
      ),
    );
  }

}