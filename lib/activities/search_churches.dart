import 'package:flutter/material.dart';
import 'package:flutter_church_location/activities/find_all_churches.dart';
import 'package:flutter_church_location/activities/show_searched_church.dart';
import 'package:flutter_church_location/database/churches_db_real.dart';
import 'package:flutter_church_location/models/church_distance.dart';
import 'package:flutter_church_location/utils/church_search_bar.dart';
import 'package:flutter_church_location/utils/connect_to_firebase_church.dart';

class SearchChurches extends StatefulWidget {
  final List<ChurchDistance> listOfChurches;

  SearchChurches(this.listOfChurches);

  @override
  _SearchChurchesState createState() => _SearchChurchesState();
}

class _SearchChurchesState extends State<SearchChurches> {
  ChurchesDB churchesDB;
  ChurchDistance churchObject;

  @override
  void initState() {
    super.initState();

    // _getChurches();

    // print([widget.listOfChurches]);
  }

  // _getChurches() async {
  //   churchesDB = await ConnectToFirebaseChurch().getChurches();
  //   int count = await churchesDB.queryRowCount();
  //   print("DATABASE COUNT: $count");
  //
  //   listOfChurches = await churchesDB.getAllChurches();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ChurchSearch(widget.listOfChurches));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  title: Text(
                    "Find all locations",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FindAllChurches([...widget.listOfChurches])));
                  }),
            ),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.listOfChurches.length,
                itemBuilder: (context, index) {
                  ChurchDistance church;
                  return Card(
                    margin: EdgeInsets.all(.5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          widget.listOfChurches[index].churchName,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onTap: () => {
                          church = widget.listOfChurches[index],
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowSearchedChurch(church)))
                        },
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
