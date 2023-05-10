class Dtext {
  int id;
  String text;
  DateTime date;

  Dtext(this.id, this.text, this.date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
    };
  }

  factory Dtext.fromMap(Map<String, dynamic> map) => Dtext(
      map['id'], map['text'], map['date']);
}

class dtakeArguments {
  final int id;
  final Dtext text;

  dtakeArguments(this.id, this.text);
}
