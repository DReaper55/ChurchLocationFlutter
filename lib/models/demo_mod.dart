class DemoMod {
  String imageUrl, uid, userName;
  int id;

  DemoMod({this.userName, this.imageUrl, this.uid, this.id});

  DemoMod.fromJson(Map<String, dynamic> json) {
    this.uid = json['uid'];
    this.userName = json['userName'];
    this.imageUrl = json['imageUrl'];
    // this.id = json['uid'];
  }

  DemoMod.fromMap(Map<String, dynamic> json) {
    this.uid = json['uid'];
    this.userName = json['userName'];
    this.imageUrl = json['imageUrl'];
    this.id = json['id'];
    // this.id = json['uid'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> demoMap = {
      'userName': this.userName,
      'imageUrl': this.imageUrl,
      'uid': this.uid
      // 'id': this.uid
    };
    return demoMap;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> demoMap = {
      'userName': this.userName,
      'imageUrl': this.imageUrl,
      'uid': this.uid,
      'id': this.id
      // 'id': this.uid
    };
    return demoMap;
  }
}
