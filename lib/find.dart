library find;
import 'dart:collection';

import 'package:flutter/widgets.dart';

class Find {

  @protected
  static HashMap<String,Widget> _widgetMap = HashMap();

  @protected
  static HashMap<String,GlobalKey> _keyMap = HashMap();

  static Widget byId(String id) {
    if(!_widgetMap.containsKey(id)) throw "Find: ID '$id' not in tree. Please double check your .byId() call and try again.";
    return _widgetMap[id];
  }

  static add({
    @required String id,
    @required Function builder,
    @required Map<String,dynamic> initial
  }) {
    // quit if exists already
    if(_widgetMap.containsKey(id)) throw "Find: ID already defined. Please remove duplicate definition and restart.";

    final Key _generatedKey = GlobalKey();

    // set initial data in dataMap
    FindData._dataMap[id] = initial;

    // add key to keyMap
    _keyMap[id] = _generatedKey;

    // set widget in widgetMap
    _widgetMap[id] = FindWidget(
      key: _generatedKey,
      id: id,
      builder: builder,
    );
  }

}

class FindData {
  @protected
  static HashMap<String,Map<String,dynamic>> _dataMap = HashMap();

  static Map<String,dynamic> get(String id) {
    return _dataMap[id];
  }

  static void set(String id, Map val) {
    _dataMap[id] = val;
  }

  static FindDataValue byId(String id) {
    if(!_dataMap.containsKey(id)) throw "Find: ID '$id' not in tree. Please double check your .byId() call and try again.";
    return FindDataValue(id);
  }

}

class FindDataValue {
  FindDataValue(this.id);
  final String id;

  @protected
  void _rebuild() => Find._keyMap[id].currentState.setState((){});

  @protected
  void set(String name, val) {
    FindData._dataMap[id][name] = val;
    _rebuild();
  }

  @protected
  void update(String name, Function builder) {
    FindData._dataMap[id][name] = builder(FindData._dataMap[id][name]);
    _rebuild();
  }

  @protected
  dynamic get(String name) => FindData._dataMap[id][name];

}

class FindWidget extends StatefulWidget {
  FindWidget({
    @required this.key,
    @required this.id,
    @required this.builder,
  });

  final GlobalKey<State<StatefulWidget>> key;
  final String id;
  final Function builder;

  @override
  _FindWidgetState createState() => _FindWidgetState();
}

class _FindWidgetState extends State<FindWidget> {
  @override
  Widget build(BuildContext context) {
//    debugPrint("FindWidget rebuilt.");
    return widget.builder(
        FindData.get(widget.id)
    );
  }
}