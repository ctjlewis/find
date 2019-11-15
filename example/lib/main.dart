import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:find/find.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {
    FindData.byId("myText").update("counter", (_counter) => _counter + 1);
    FindData.byId("anotherText").update("text", (_txt) => _txt + "!");
//    debugPrint(FindData.byId("myTest").get("counter").toString());
  }

  @override
  void initState() {
    super.initState();

    Find.add(
      id: "myText",
      initial: {
        "counter": 0,
      },
      builder: (Map _data) => Text(_data["counter"].toString(), style: TextStyle(fontSize: 24.0),),
    );

    Find.add(
      id: "anotherText",
      initial: {
        "text": "hello",
      },
      builder: (Map _data) => Text(_data["text"]),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Find.byId("myText"),
            Find.byId("anotherText"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
