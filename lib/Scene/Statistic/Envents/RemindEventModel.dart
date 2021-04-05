
enum RemindEventType {
  orderTimesLimit,
  orderExpireTime,
  birthDay,
}

enum RemindEventState {
  // 未读
  unRead,
  // 已读
  readed,
}

class RemindEventModel {

  int id = 0;
  int refer_id = 0;
  RemindEventType type;
  RemindEventState state;
  int create_time = 0;
  int update_time = 0;


}