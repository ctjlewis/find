import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:find/find.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  enablePlatformOverrideForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool toggle = false;
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];
  double _value = 50.0;

  @override
  void initState() {
    super.initState();
    dataMap.putIfAbsent("Flutter", () => 5);
    dataMap.putIfAbsent("React", () => 3);
    dataMap.putIfAbsent("Xamarin", () => 2);
    dataMap.putIfAbsent("Ionic", () => 2);

    FindData.addInitialState("chartData", dataMap);
    FindData.addInitialState("slider", {
      "value": 50.0,
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Pie Chart"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: toggle
                ? PieChart(
              dataMap: FindData.get("chartData"),
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width / 2.7,
              showChartValuesInPercentage: true,
              showChartValues: true,
              showChartValuesOutside: false,
              chartValueBackgroundColor: Colors.grey[200],
              colorList: colorList,
              showLegends: true,
              legendPosition: LegendPosition.right,
              decimalPlaces: 1,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
              ),
            )
                : Text("Press FAB to show chart"),
          ),
          Slider(
            min: 0.0,
            max: 100.0,
            value: _value,
            onChanged: (i) => setState(() => _value = i),
          ),
          Find.add(
            id: "slider",
            initialState: {
              "value": 50.0,
            },
            builder: (i) => MySlider(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: togglePieChart,
        child: Icon(Icons.insert_chart),
      ),
    );
  }

  void togglePieChart() {
    setState(() {
      toggle = !toggle;
    });
  }
}

class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  @override
  Widget build(BuildContext context) {

    return Find.add(
      id: "slider",
      initialState: {
        "value": 0.0,
      },
      builder: (_state) => Slider(
        value: _state["value"],
        onChanged: (double v) =>
            setState(
                    (){
                  debugPrint("Slider: $v");
                  final double _pct = v/100;
                  final double _init = FindData.getInitialValue("chartData", "Flutter");
                  FindData.setValue("slider", "value", v);
                  FindData.setValue("chartData", "Flutter", _init*_pct);
                }
            ),
        min: 0.0,
        max: 100.0,
      ),
    );

//    return Slider(
//      value: FindData.getValue("slider", "value"),
//      onChanged: (double v) =>
//          setState(
//              (){
//                debugPrint("Slider: $v");
//                final double _pct = v/100;
//                final double _init = FindData.getInitialValue("chartData", "Flutter");
//                FindData.setValue("slider", "value", v);
//                FindData.setValue("chartData", "Flutter", _init*_pct);
//              }
//          ),
//      min: 0.0,
//      max: 100.0,
//    );
  }
}

