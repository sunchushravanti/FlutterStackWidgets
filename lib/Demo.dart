import 'dart:convert';

class Demo_Record {
  String title;
  String shortDescription;
  int collectedValue;
  int totalValue;
  String startDate;
  String endDate;
  String mainImageURL;
  int id;
  bool favValue=false;

  List<Demo_Record> _recordList;
  var recordObjsJson;

  Demo_Record(this.title, this.shortDescription,
      this.collectedValue, this.totalValue, this.startDate, this.endDate,
      this.mainImageURL,this.id,this.favValue);


  Demo_Record.fromJson(Map<String, dynamic> json) {
    if (json['Records'] != null) {
      recordObjsJson = json['Records'] ;
    }
  }


  static String listToJson(var record) {
    List<dynamic> x = record.map((f) =>
    {
      "mainImageURL": f,
       }).toList();

    String result = jsonEncode(x);
    return result;
  }
}