
import 'package:flutter/material.dart';
import 'package:store_keeper_app/screen/home_screen.dart' ;
import 'package:store_keeper_app/screen/start_screen.dart' ;
import 'package:store_keeper_app/screen/search_screen.dart' ;
import 'package:store_keeper_app/widgets/components/responsive_navigation.dart';
import 'package:store_keeper_app/screen/edit_screen.dart' ;
import 'package:store_keeper_app/screen/product_screen.dart' ;
import 'package:store_keeper_app/screen/all_screen.dart' ;
import 'package:store_keeper_app/screen/create_screen.dart' ;
class RouteGenerator {
  static const String initial = '/';
  static const String home = '/home';
 static const String  create  = '/create';
  static const String search = '/search';
  static const String all = '/all';
   static const String product = '/product';
    static const String editproduct = '/edit-product';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => ResponsiveNavigation());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case create:
        return MaterialPageRoute(builder: (_) => CreateScreen());
      case search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case all:
        return MaterialPageRoute(builder: (_) => AllScreen());
      case product:
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductScreen(productId : productId),
        );
       case editproduct:
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => EditScreen(productId : productId),
        );
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