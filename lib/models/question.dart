import 'option.dart';

class Question {
  late String text;
  late int duration;
  late bool shuffleOptions;
  late List<Option> options;
  late String image;

  Question(
      this.text,
      this.duration,
      this.shuffleOptions,
      this.options,
      this.image,
      );

  Question.fromJson(dynamic json) {
    text = json["text"];
    duration = json["duration"];
    shuffleOptions = json["shuffleOptions"];
    image = json["image"];
    options = List<Option>.from(json["options"].map((x) => Option.fromJson(x)));
  }

  static jsonToObject(dynamic json) {
    List<Option> options = [];
    if (json["options"] != null) {
      options =
      List<Option>.from(json["options"].map((x) => Option.fromJson(x)));
    }
    return Question(
        json["text"], json["duration"], json["shuffleOptions"], options,json["image"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["text"] = text;
    map["duration"] = duration;
    map["shuffleOptions"] = shuffleOptions;
    map["image"] = image;
    map["options"] = List<dynamic>.from(options.map((x) => x.toJson()));
    return map;
  }
}
