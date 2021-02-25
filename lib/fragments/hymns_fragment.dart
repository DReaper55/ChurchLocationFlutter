import 'package:flutter/material.dart';
import 'package:flutter_church_location/activities/hymn.dart';
import 'package:flutter_church_location/utils/hymn_search_bar.dart';
import 'package:flutter_church_location/utils/hymn_songs.dart';

class HymnsFragment extends StatefulWidget {
  // final List<String> list = List.generate(10, (index) => "Text $index");

  final List<Map<String, String>> hymnSongs = HymnSong().hymnSongs();

  @override
  _HymnsState createState() => _HymnsState();
}

class _HymnsState extends State<HymnsFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          snap: true,
          // confirm this
          floating: true,
          title: Text('Hymn Book'),
          expandedHeight: 250,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: Search(widget.hymnSongs));
              },
            ),
            PopupMenuButton(
                onSelected: _handleMenuClick,
                itemBuilder: (context) {
                  return {'about', 'settings'}
                      .map((e) => PopupMenuItem<String>(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: Text(e),
                            ),
                            value: e,
                          ))
                      .toList();
                })
          ],
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Card(
                      margin: EdgeInsets.all(.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Text(widget.hymnSongs[index]['number']),
                          title: Text(
                            widget.hymnSongs[index]['title'],
                            textAlign: TextAlign.center,
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Hymn(
                                      widget.hymnSongs[index]['title'],
                                      widget.hymnSongs[index]['hymnSong']))),
                        ),
                      ),
                    ),
                childCount: widget.hymnSongs.length))
      ],
    ));
  }
}

void _handleMenuClick(String value) {
  switch (value) {
    case 'about':
      break;
    case 'settings':
      break;
  }
}
