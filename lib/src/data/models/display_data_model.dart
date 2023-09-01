class DisplayDataModel {
  final String? title;
  final String? subTitle;
  final List<dynamic>? list;

  DisplayDataModel({
    this.title,
    this.subTitle,
    this.list,
  });
  factory DisplayDataModel.fromJson(Map<String, dynamic> json) =>
      DisplayDataModel(
        title: json['title'],
        subTitle: json['subtitle'],
        list: json['list'],
      );
}
