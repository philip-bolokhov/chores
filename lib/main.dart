import 'package:chores/routing_constants.dart';
import 'package:flutter/material.dart';
import 'router.dart';

void main() {
  Future.delayed(Duration(seconds: 3), () {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  static const MAX_PAGE_WIDTH = 800;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > MAX_PAGE_WIDTH) {
        return _wideLayout(constraints);
      } else {
        return _normalLayout();
      }
    });
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
