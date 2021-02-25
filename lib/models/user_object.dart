class UserObject {
  String fullname,
      email,
      password,
      title,
      gender,
      church,
      displayPic,
      id,
      leaderCountry,
      username,
      state,
      dateOfBirth,
      dateOfBaptism,
      bio,
      hobby,
      emailVerification,
      titleVerification;

  String status;

  int dbId; // for the database

  UserObject();

  UserObject.full(
    String fullname,
    String email,
    String password,
    String title,
    String gender,
    String church,
    String id,
    String leaderCountry,
    String username,
    String state,
    String dateOfBirth,
    String dateOfBaptism,
    String emailVerification,
    String titleVerification,
    String bio,
    String hobby,
  ) {
    this.fullname = fullname;
    this.email = email;
    this.password = password;
    this.title = title;
    this.gender = gender;
    this.church = church;
    this.id = id;
    this.leaderCountry = leaderCountry;
    this.username = username;
    this.state = state;
    this.dateOfBirth = dateOfBirth;
    this.dateOfBaptism = dateOfBaptism;
    this.emailVerification = emailVerification;
    this.titleVerification = titleVerification;
    this.bio = bio;
    this.hobby = hobby;
  }

  UserObject.request(String fullname, String email, String church, String id,
      String status, String username, String leaderCountry) {
    this.fullname = fullname;
    this.email = email;
    this.church = church;
    this.id = id;
    this.status = status;
    this.username = username;
    this.leaderCountry = leaderCountry;
  }

  UserObject.requestFromMap(Map<dynamic, dynamic> list) {
    this.fullname = list['fullname'];
    this.email = list['email'];
    this.church = list['church'];
    this.leaderCountry = list['leaderCountry'];
    this.username = list['username'];
    this.status = list['status'];
    this.id = list['id'];
  }

  Map<String, dynamic> requestToMap() {
    return <String, dynamic>{
      'fullname': this.fullname,
      'email': this.email,
      'church': this.church,
      'leaderCountry': this.leaderCountry,
      'username': this.username,
      'status': this.status,
      'id': this.id,
    };
  }

  UserObject.fromMap(Map<dynamic, dynamic> list) {
    this.state = list['state'];
    this.fullname = list['fullname'];
    this.email = list['email'];
    this.title = list['title'];
    this.gender = list['gender'];
    this.church = list['church'];
    this.id = list['id'];
    this.leaderCountry = list['leaderCountry'];
    this.username = list['username'];
    this.dateOfBirth = list['dateOfBirth'];
    this.dateOfBaptism = list['dateOfBaptism'];
    this.emailVerification = list['emailVerification'];
    this.titleVerification = list['titleVerification'];
    this.bio = list['bio'];
    this.hobby = list['hobby'];
  }

  UserObject.fromMapDB(Map<String, dynamic> list) {
    this.state = list['state'];
    this.fullname = list['fullname'];
    this.email = list['email'];
    this.title = list['title'];
    this.gender = list['gender'];
    this.church = list['church'];
    this.id = list['id'];
    this.dbId = list['dbId'];
    this.leaderCountry = list['leaderCountry'];
    this.username = list['username'];
    this.dateOfBirth = list['dateOfBirth'];
    this.dateOfBaptism = list['dateOfBaptism'];
    this.emailVerification = list['emailVerification'];
    this.titleVerification = list['titleVerification'];
    this.bio = list['bio'];
    this.hobby = list['hobby'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'state': this.state,
      'fullname': this.fullname,
      'email': this.email,
      'title': this.title,
      'gender': this.gender,
      'church': this.church,
      'id': this.id,
      'leaderCountry': this.leaderCountry,
      'username': this.username,
      'dateOfBirth': this.dateOfBirth,
      'dateOfBaptism': this.dateOfBaptism,
      'emailVerification': this.emailVerification,
      'titleVerification': this.titleVerification,
      'bio': this.bio,
      'hobby': this.hobby,
    };
  }

  Map<String, dynamic> toMapDB() {
    return <String, dynamic>{
      'state': this.state,
      'fullname': this.fullname,
      'email': this.email,
      'title': this.title,
      'gender': this.gender,
      'church': this.church,
      'id': this.id,
      'dbId': this.dbId,
      'leaderCountry': this.leaderCountry,
      'username': this.username,
      'dateOfBirth': this.dateOfBirth,
      'dateOfBaptism': this.dateOfBaptism,
      'emailVerification': this.emailVerification,
      'titleVerification': this.titleVerification,
      'bio': this.bio,
      'hobby': this.hobby,
    };
  }
}
