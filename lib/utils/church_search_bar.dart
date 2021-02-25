import 'package:flutter/material.dart';
import 'package:flutter_church_location/models/church_distance.dart';

class ChurchSearch extends SearchDelegate {
  final List<ChurchDistance> lists;

  ChurchSearch(this.lists);

  List<ChurchDistance> _newList = [];

  bool _queryList(String item) {
    _newList.clear();

    lists.forEach((element) {
      if (element.churchName.contains(item)) {
        // may add countries to the search result later on
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
                      title: Text(
                        _newList[index].churchName,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => null)),
                    ),
                  ),
                ))
        : null;
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) => Card(
              margin: EdgeInsets.all(.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    lists[index].churchName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => null)),
                ),
              ),
            ));
  }
}
