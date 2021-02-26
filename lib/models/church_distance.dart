class ChurchDistance {
  String churchName,
      pastorName,
      address,
      state,
      country,
      about,
      number,
      disciples,
      region;
  double distance, churchLat, churchLng;
  int id;

  ChurchDistance(
      {this.churchName, this.churchLat, this.churchLng, this.distance});

  ChurchDistance.distance(this.distance);

  ChurchDistance.details(
      {this.churchName,
      this.churchLat,
      this.churchLng,
      this.distance,
      this.about,
      this.address,
      this.country,
      this.disciples,
      this.number,
      this.pastorName,
      this.region,
      this.id,
      this.state});

  ChurchDistance.fromJsonList(List<Map<String, dynamic>> list, int index) {
    this.state = list[index]['state'];
    this.churchName = list[index]['churchName'];
    this.churchLat = double.parse(list[index]['churchLat']);
    this.churchLng = double.parse(list[index]['churchLng']);
    this.about = list[index]['about'];
    this.address = list[index]['address'];
    this.country = list[index]['country'];
    this.number = list[index]['number'];
    this.pastorName = list[index]['pastorName'];
    this.region = list[index]['region'];
  }

  ChurchDistance.fromJson(Map<String, dynamic> list) {
    this.state = list['state'];
    this.churchName = list['churchName'];
    this.churchLat = list['churchLat'];
    this.churchLng = list['churchLng'];
    this.about = list['about'];
    this.address = list['address'];
    this.country = list['country'];
    this.number = list['number'];
    this.pastorName = list['pastorName'];
    this.region = list['region'];
  }

  ChurchDistance.fromMap(Map<String, dynamic> list) {
    this.state = list['state'];
    this.churchName = list['churchName'];
    this.churchLat = double.parse(list['churchLat']);
    this.churchLng = double.parse(list['churchLng']);
    this.about = list['about'];
    this.address = list['address'];
    this.country = list['country'];
    this.number = list['number'];
    this.pastorName = list['pastorName'];
    this.region = list['region'];
    this.id = list['id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> churchJson = {
      'state': this.state,
      'churchName': this.churchName,
      'churchLat': this.churchLat,
      'churchLng': this.churchLng,
      'about': this.about,
      'address': this.address,
      'country': this.country,
      'number': this.number,
      'pastorName': this.pastorName,
      'region': this.region
      // 'id': this.uid
    };
    return churchJson;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> churchJson = {
      'state': this.state,
      'churchName': this.churchName,
      'churchLat': this.churchLat,
      'churchLng': this.churchLng,
      'about': this.about,
      'address': this.address,
      'country': this.country,
      'number': this.number,
      'pastorName': this.pastorName,
      'region': this.region,
      'id': this.id
    };
    return churchJson;
  }
}
