library find;
import 'dart:collection';
import 'package:flutter/widgets.dart';

class Find {

  static HashMap<String,FindWidgetBuilder> builderMap = HashMap();
  static HashMap<String,State<StatefulWidget>> stateMap = HashMap();
  static bool idExists(String id) => builderMap.containsKey(id);

  static Widget byId(String id) => builderMap[id].build();
  static State<StatefulWidget> getState(String id) => stateMap[id];
  static void setState(String id, State<StatefulWidget> state) => stateMap[id] = state;

  static add({
    @required String id,
    @required Function builder,
    @required Map<String,dynamic> initialState
  }) {

    // set initial data in dataMap
    FindData.set(id, initialState);

    // set widget in widgetMap
    builderMap[id] = FindWidgetBuilder(
      () => FindWidget(
        id: id,
        builder: builder,
      ),
    );
  }

}

class FindData {

  static HashMap<String,Map<String,dynamic>> _dataMap = HashMap();

  static Map<String,dynamic> get(String id) => _dataMap[id];
  static dynamic getValue(String id, String name) => _dataMap[id][name];

  static void set(String id, Map<String,dynamic> val) => _dataMap[id] = val;
  static void setValue(String id, String name, dynamic val) => _dataMap[id][name] = val;

  static FindDataValue byId(String id) => FindDataValue(id);

}

class FindWidgetBuilder {
  FindWidgetBuilder(this.builder);
  final Function builder;

  FindWidget build() => builder();
}

class FindDataValue {
  FindDataValue(this.id);
  final String id;

  dynamic get(String name) => FindData.getValue(id, name);

  void set(String name, dynamic val) {
    FindData.setValue(id, name, val);
    _rebuild();
  }

  void update(String name, Function builder) {
    FindData.setValue(id, name, builder(FindData.getValue(id, name)));
    _rebuild();
  }

  @protected
  void _rebuild() => Find.getState(id).setState((){});

}

class FindWidget extends StatefulWidget {
  FindWidget({
    @required this.id,
    @required this.builder,
  });

  final String id;
  final Function builder;

  @override
  _FindWidgetState createState() => _FindWidgetState();
}

class _FindWidgetState extends State<FindWidget> {

  @override
  void initState() {
    super.initState();
    Find.setState(widget.id, this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        FindData.get(widget.id)
    );
  }
}