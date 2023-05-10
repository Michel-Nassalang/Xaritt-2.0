class Chatlist {
  int id;
  String title;
  DateTime date;

  Chatlist(this.id, this.title, this.date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
    };
  }

  factory Chatlist.fromMap(Map<String, dynamic> map) => Chatlist(
      map['id'], map['title'], map['date']);
}

class cltakeArguments {
  final int id;
  final Chatlist chatlist;

  cltakeArguments(this.id, this.chatlist);
}
