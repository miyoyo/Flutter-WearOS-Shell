import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final navkey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        WearObserver(),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class WearObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    print("didPop");
    if (previousRoute == null) return;

    if (!previousRoute.hasActiveRouteBelow) {
      WearSlideControl.allowSwipe();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print("didReplace");
    if (newRoute == null) return;

    if (!newRoute.hasActiveRouteBelow) {
      WearSlideControl.allowSwipe();
    }
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    // nothing
  }

  @override
  void didStopUserGesture() {
    // nothing
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    print("didRemove");
    if (previousRoute == null) return;

    if (!previousRoute.hasActiveRouteBelow) {
      WearSlideControl.allowSwipe();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    print("didPush");
    if (!route.hasActiveRouteBelow && previousRoute == null) {
      print("CanSwipe!");
      WearSlideControl.allowSwipe();
    } else {
      WearSlideControl.banSwipe();
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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

class WearSlideControl {
  static final _method = MethodChannel("io.flutter.wear");

  static var currentStatus = false;

  static Future<bool> banSwipe() async {
    final result = await _method.invokeMethod("banSwipe");
    return result as bool;
  }

  static Future<bool> allowSwipe() async {
    final result = await _method.invokeMethod("allowSwipe");

    return result as bool;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  bool canSwipe = false;

  void _incrementCounter() async {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (_) => Junk()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
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

class Junk extends StatelessWidget {
  const Junk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Junk!"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => Junk()),
          );
        },
      ),
    );
  }
}
