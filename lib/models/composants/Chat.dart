class Chat {
  int id;
  String msg;
  int chatIndex;
  int idChatlist;
  DateTime date;

  Chat(this.id, this.msg, this.chatIndex, this.idChatlist, this.date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'msg': msg,
      'chatIndex': chatIndex,
      'idChatlist': idChatlist,
      'date': date,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
      map['id'],
      map['msg'],
      map['chatIndex'],
      map['idChatlist'],
      map['date']);
}

class ctakeArguments {
  final int id;
  final Chat chat;

  ctakeArguments(this.id, this.chat);
}
