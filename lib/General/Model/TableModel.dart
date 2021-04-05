class TableModel {

  int id = 0;

  String descript = '';

  int createTime = DateTime.now().millisecondsSinceEpoch;

  int modifyTime = DateTime.now().millisecondsSinceEpoch;

  TableModel(){}

  TableModel.withMap(Map map) {
    this.id = map['id'] ?? -1;
    this.descript = map['descript'] ?? '';
    this.createTime = map['create_time'] ?? 0;
    this.modifyTime = map['modify_time'] ?? 0;
  }

  static List<TableModel> modesFromList(List<Map> list) {
    List<TableModel> temp = [];
    list.forEach((map) {
      temp.add(TableModel.withMap(map));
    });
    return temp;
  }

}