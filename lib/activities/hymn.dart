import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hymn extends StatefulWidget {
  final String title, hymn;

  Hymn(this.title, this.hymn);

  @override
  _HymnState createState() => _HymnState();
}

class _HymnState extends State<Hymn> with WidgetsBindingObserver {
  static const String ZOOM_KEY = 'zoom_counter';
  SharedPreferences _preferences;
  static double fontSize = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _incrementCounter();
  }

  _incrementCounter() async {
    _preferences = await SharedPreferences.getInstance();
    double counter = _preferences.getDouble(ZOOM_KEY);

    if (counter != null && counter > 0) {
      setState(() {
        fontSize = counter;
      });
    }
  }

  void _zoomOut() {
    setState(() {
      fontSize = (fontSize > 10) ? fontSize - 5 : fontSize;
      _preferences.setDouble(ZOOM_KEY, fontSize);
      print("zoom out $fontSize");
    });
  }

  void _zoomIn() {
    setState(() {
      fontSize = (fontSize < 30) ? fontSize + 5 : fontSize;
      _preferences.setDouble(ZOOM_KEY, fontSize);

      print("zoom in $fontSize");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SelectableText(
          widget.hymn,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: fontSize),
        ),
      ),
      floatingActionButton: UnicornDialer(
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: _getChildFab(),
      ),
    );
  }

  List<UnicornButton> _getChildFab() {
    List<UnicornButton> children = [];

    children.add(_fabWidget(
        iconData: Icons.add,
        label: "Zoom in",
        heroTag: "zoom_in",
        onPressed: _zoomIn));
    children.add(_fabWidget(
        iconData: Icons.remove,
        label: "Zoom out",
        heroTag: "zoom_out",
        onPressed: _zoomOut));

    return children;
  }

  Widget _fabWidget(
      {IconData iconData, Function onPressed, String label, String heroTag}) {
    return UnicornButton(
      labelText: label,
      currentButton: FloatingActionButton(
        heroTag: heroTag,
        child: Icon(iconData),
        onPressed: onPressed,
        backgroundColor: Theme.of(context).accentColor,
        mini: true,
      ),
    );
  }
}
