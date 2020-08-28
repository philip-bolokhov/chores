import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './routing_constants.dart';
import './router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.delayed(Duration(seconds: 3), () {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  static const MAX_PAGE_WIDTH = 800;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
              child: Text(
            "Firebase connection error",
            textDirection: TextDirection.ltr,
          )); // AAAA
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > MAX_PAGE_WIDTH) {
              return _wideLayout(constraints);
            } else {
              return _normalLayout();
            }
          });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
            child: Text(
          "Loading",
          textDirection: TextDirection.ltr,
        )); // AAAA
      },
    );
  }

  Widget _mainApp() {
    return MaterialApp(
      title: 'Daily Chore',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: generateRoutes,
      initialRoute: LoginPageViewRoute,
    );
  }

  Widget _wideLayout(BoxConstraints constraints) {
    double padding = (constraints.maxWidth - MAX_PAGE_WIDTH) / 2.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: _mainApp(),
    );
  }

  Widget _normalLayout() {
    return _mainApp();
  }
}
