import 'package:flutter/material.dart';
import 'package:flutter_church_location/activities/hymn.dart';

class Search extends SearchDelegate {
  final List<Map<String, String>> lists;
  String selectedResult = "";

  Search(this.lists);

  // List<Map<String, String>> list = () {
  //   return <Map<String, String>>[];
  // } as List<Map<String, String>>;

  List<Map<String, String>> _newList = [];

  bool _queryList(String item) {
    _newList.clear();

    lists.forEach((element) {
      if (element['title'].contains(item) || element['number'].contains(item)) {
        _newList.add(element);
      }
    });
    return true;
  }

  Widget _buildResultWidget(String item) {
    return _queryList(item)
        ? ListView.builder(
            itemCount: _newList == null ? lists.length : _newList.length,
            itemBuilder: (context, index) => Card(
              margin: EdgeInsets.all(.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Text(_newList[index]['number']),
                  title: Text(
                    _newList[index]['title'],
                    textAlign: TextAlign.center,
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Hymn(_newList[index]['title'],
                              _newList[index]['hymnSong']))),
                ),
              ),
            ),
          )
        : null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: lists.length,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.all(.5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Text(lists[index]['number']),
            title: Text(
              lists[index]['title'],
              textAlign: TextAlign.center,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Hymn(lists[index]['title'], lists[index]['hymnSong']))),
          ),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
          _newList.clear();
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultWidget(query);
  }
}
