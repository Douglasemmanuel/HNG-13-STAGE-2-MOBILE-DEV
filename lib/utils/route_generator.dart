
import 'package:flutter/material.dart';
import 'package:store_keeper_app/screen/home_screen.dart' ;
import 'package:store_keeper_app/screen/start_screen.dart' ;
import 'package:store_keeper_app/screen/create_scren.dart' ;
import 'package:store_keeper_app/screen/search_screen.dart' ;
import 'package:store_keeper_app/widgets/components/responsive_navigation.dart';

class RouteGenerator {
  static const String initial = '/';
  static const String home = '/home';
 static const String  create  = '/create';
  static const String search = '/search';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => ResponsiveNavigation());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case create:
        return MaterialPageRoute(builder: (_) => CreateScren());
      case search:
        return MaterialPageRoute(builder: (_) => SearchScreen());

      default:
        return _errorRoute();
    }
  }

  // This method is outside the generateRoute method — at class level!
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}