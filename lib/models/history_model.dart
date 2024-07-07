class HistoryModel {
  int? id;
  String expression;
  String result;

  HistoryModel({this.id, required this.expression, required this.result});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      expression: map['expression'],
      result: map['result'],
    );
  }
}
