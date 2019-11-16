library find;
import 'dart:collection';
import 'package:flutter/widgets.dart';

class Find {

  static HashMap<String,FindWidget> builderMap = HashMap();
  static HashMap<String,State<StatefulWidget>> stateMap = HashMap();
  static bool idExists(String id) => builderMap.containsKey(id);

  static Widget byId(String id) => builderMap[id];
  static State<StatefulWidget> getState(String id) => stateMap[id];
  static void setState(String id, State<StatefulWidget> state) => stateMap[id] = state;

  static FindWidget add({
    @required String id,
    @required Function builder,
    @required Map initialState
  }) {

    debugPrint("FindWidget.add called");

    // set initial data in dataMap
    FindData.addInitialState(id, initialState);

    // set widget in widgetMap
//    final FindWidget _res = FindWidget(
//      id: id,
//      builder: builder,
//    );

    builderMap[id] = FindWidget(
      id: id,
      builder: builder,
    );

    return builderMap[id];
  }
}

class FindWidgetBuilder {
  FindWidgetBuilder({@required this.id, @required this.builder});
  final String id;
  final Function builder;

  FindWidget build() => FindWidget(id: id, builder: builder);
}

class FindData {

  static HashMap<String,Map> _dataMap = HashMap();
  static HashMap<String,Map> _initialsMap = HashMap();

  static void addInitialState(String id, Map initialState) {
    _dataMap[id] = initialState;
    _initialsMap[id] = Map.unmodifiable(initialState);
  }
  static Map getInitialState(String id) => _initialsMap[id];
  static dynamic getInitialValue(String id, String name) => getInitialState(id)[name];

  static Map get(String id) => _dataMap[id];
  static dynamic getValue(String id, String name) => _dataMap[id][name];

  static void set(String id, Map val) => _dataMap[id] = val;
  static void setValue(String id, String name, dynamic val) => _dataMap[id][name] = val;

  static void update(String id, Function builder) => set(id, builder(get(id)));
  static void updateValue(String id, String name, Function builder)
  => setValue(id, name, builder(getValue(id, name)));

  static IdDataTable byId(String id) => IdDataTable(id);

}

class IdDataTable {
  IdDataTable(this.id);
  final String id;

  dynamic get(String name) => FindData.getValue(id, name);

  void set(Map val) {
    FindData.set(id, val);
    rebuild();
  }

  void setValue(String name, dynamic val) {
    FindData.setValue(id, name, val);
    rebuild();
  }

  void update(Function builder) {
    FindData.set(id, builder(FindData.get(id)));
    rebuild();
  }

  void updateValue(String name, Function builder) {
    FindData.setValue(id, name, builder(FindData.getValue(id, name)));
    rebuild();
  }

  void rebuild() {
    final State<StatefulWidget> _curState = Find.getState(id);
    if(_curState == null) return;
    else _curState.setState((){});
  }

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