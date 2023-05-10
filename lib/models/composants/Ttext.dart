class Ttext {
  int id;
  String text;
  String ttext;
  DateTime date;

  Ttext(this.id, this.text, this.ttext, this.date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'ttext': ttext,
      'date': date,
    };
  }

  factory Ttext.fromMap(Map<String, dynamic> map) =>
      Ttext(map['id'], map['text'], map['ttext'], map['date']);
}

class ttakeArguments {
  final int id;
  final Ttext text;

  ttakeArguments(this.id, this.text);
}
