class Reward {
  late int id;
  late String name;
  late String imagePath;

  Reward(this.id, this.name, this.imagePath,);

  Reward.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    imagePath = json["imagePath"];
  }

  static jsonToObject(dynamic json) {
    return Reward(json["id"], json["name"], json["imagePath"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["imagePath"] = imagePath;
    return map;
  }
}
