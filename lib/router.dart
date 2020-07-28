import 'package:chores/edit_chore_view.dart';
import 'package:chores/routing_constants.dart';
import 'package:flutter/material.dart';
import 'home_page_view.dart';

Route<dynamic> generateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomePageViewRoute:
      return MaterialPageRoute(builder: (context) => HomePageView());

    case EditChoreViewRoute:
      return MaterialPageRoute(
          builder: (context) => EditChoreView(chore: routeSettings.arguments));

    default:
      return MaterialPageRoute(builder: (context) => HomePageView());
  }
}
