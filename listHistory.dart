class ListHistory {
  ListHistory(
    this.type,
    this.comment,
    this.date,
  );
  String type;
  String comment;
  DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'comment': comment,
      'date': date,
    };
  }

  @override
  String toString() {
    return "type : $type\ncomment : $comment\ndate: $date";
  }
}