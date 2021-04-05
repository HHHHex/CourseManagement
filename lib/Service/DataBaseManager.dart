import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseManager {
  factory DataBaseManager() => shared();

  static  DataBaseManager _instance;

  static DataBaseManager shared(){
    if(_instance == null){
      _instance = DataBaseManager._();
    }
    return _instance;
  }

  String dbPath;
  static const String lesson = 'lesson';
  static const String coach = 'coach';
  static const String member = 'member';
  static const String order = 'order_form';
  static const String engage = 'engage';
  static const String remind = 'remind';

  final _dbName = 'USER.db';
  final _sql_create_table_lesson = 'CREATE TABLE $lesson (id INTEGER PRIMARY KEY, lesson_name TEXT, duration REAL, price REAL, coach_id INTEGER, descript TEXT, create_time INTEGER, modify_time INTEGER)';
  final _sql_create_table_coach = 'CREATE TABLE $coach (id INTEGER PRIMARY KEY, coach_name TEXT, number Text, gender INTEGER, descript TEXT, create_time INTEGER, modify_time INTEGER)';
  final _sql_create_table_member = 'CREATE TABLE $member (id INTEGER PRIMARY KEY, member_name TEXT, gender INTEGER, birth_day INTEGER, contact TEXT, coach_id INTEGER, descript TEXT, create_time INTEGER, modify_time INTEGER)';
  final _sql_create_table_order = 'CREATE TABLE $order (id INTEGER PRIMARY KEY, member_id INTEGER, coach_id INTEGER, lesson_id INTEGER, total_times INTEGER, remain_times INTEGER, single_price REAL, earning REAL, expire_time INTEGER, descript TEXT, create_time INTEGER, modify_time INTEGER)';
  final _sql_create_table_engage = 'CREATE TABLE $engage (id INTEGER PRIMARY KEY, member_id INTEGER, order_id INTEGER, coach_id INTEGER, lesson_id INTEGER, start_time INTEGER, duration REAL, descript TEXT, create_time INTEGER, modify_time INTEGER, state INTEGER)';
  final _sql_create_table_remind = 'CREATE TABLE $remind (id INTEGER PRIMARY KEY, refer_id INTEGER, type INTEGER, state INTEGER, create_time INTEGER, update_time INTEGER)';

  final String sql_query_count = 'SELECT COUNT(*) FROM user_table';

  String sql_query = 'SELECT * FROM user_table';

  DataBaseManager._() {
  }

  Future<void> initialization() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory);
    String path = join(documentsDirectory.path, _dbName);
    await databaseExists(path).then((isExist) async {
      if (isExist) {
        print('存在数据库');
        dbPath = path;
      } else {
        try {
          await new Directory(dirname(path)).create(recursive: true);
          Database db = await openDatabase(path);
          /*执行sql 创建表*/
          await db.execute(_sql_create_table_lesson);
          await db.execute(_sql_create_table_coach);
          await db.execute(_sql_create_table_member);
          await db.execute(_sql_create_table_order);
          await db.execute(_sql_create_table_engage);
          await db.execute(_sql_create_table_remind);
          await db.close();
          print('数据库创建成功');
          dbPath = path;
        } catch (e) {
          print(e);
        }
      }
    });
  }


}