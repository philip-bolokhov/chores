import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Daily Chore',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text(
        'Welcome In SplashScreen',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset("images/sparks_fly.jpg"),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Chores');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _choreChecked = [
    false,
    false,
    false,
    false,
  ];
  var _completeChoresChecked = [
    true,
    true,
  ];

  @override
  Widget build(BuildContext context) {
    var _chores = [
      "Water the flowers",
      "Brush the cat",
      "Cook dinner",
      "Morning exercise",
    ];
    var _completeChores = [
      "Play Valorant",
      "Play Fortnite",
    ];
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      // The number of tabs / content sections to display.
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(text: "Open"),
            Tab(text: "Complete"),
          ]),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: TabBarView(children: [
          ListView.builder(
            itemBuilder: (context, position) {
              return CheckboxListTile(
                title: Text(_chores[position]),
                value: _choreChecked[position],
                secondary: Icon(Icons.schedule),
                onChanged: (bool newValue) {
                  setState(() {
                    _choreChecked[position] = newValue;
                  });
                },
              );
            },
            itemCount: _chores.length,
          ),
          ListView.builder(
            itemBuilder: (context, position) {
              return CheckboxListTile(
                title: Text(_completeChores[position]),
                value: _completeChoresChecked[position],
                secondary: Icon(Icons.schedule),
                onChanged: (bool newValue) {
                  setState(() {
                    _completeChoresChecked[position] = newValue;
                  });
                },
              );
            },
            itemCount: _completeChores.length,
          ),
        ]),
      ),
    );
  }
}
