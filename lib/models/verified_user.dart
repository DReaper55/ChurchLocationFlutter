class VerifiedUser {
  String uid, fullname, displayPic, username;

  int id;

  VerifiedUser();

  VerifiedUser.full(
      {this.id, this.uid, this.fullname, this.displayPic, this.username});

  VerifiedUser.fromMap(Map<String, dynamic> list) {
    this.uid = list['uid'];
    this.fullname = list['fullname'];
    this.displayPic = list['displayPic'];
    this.username = list['username'];
  }

  VerifiedUser.fromDBMap(Map<String, dynamic> list) {
    this.id = list['id'];
    this.uid = list['uid'];
    this.fullname = list['fullname'];
    this.displayPic = list['displayPic'];
    this.username = list['username'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': this.uid,
      'fullname': this.fullname,
      'displayPic': this.displayPic,
      'username': this.username,
    };
  }

  Map<String, dynamic> toMapDB() {
    return <String, dynamic>{
      'uid': this.uid,
      'id': this.id,
      'fullname': this.fullname,
      'displayPic': this.displayPic,
      'username': this.username,
    };
  }
}
