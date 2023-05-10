class Rtext {
  int id;
  String text;
  DateTime date;

  Rtext(this.id, this.text, this.date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
    };
  }

  factory Rtext.fromMap(Map<String, dynamic> map) => Rtext(
      map['id'], map['text'], map['date']);
}

class rtakeArguments {
  final int id;
  final Rtext text;

  rtakeArguments(this.id, this.text);
}
