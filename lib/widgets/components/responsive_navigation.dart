import 'package:flutter/material.dart';
import 'package:store_keeper_app/utils/route_generator.dart' ;
import 'package:store_keeper_app/utils/responsive_breakpoints.dart' ;
import 'package:store_keeper_app/screen/home_screen.dart' ;
import 'package:store_keeper_app/screen/create_screen.dart' ;
import 'package:store_keeper_app/screen/search_screen.dart' ;

class ResponsiveNavigation extends StatefulWidget {
  final int intialIndex;
  const ResponsiveNavigation({super.key , this.intialIndex = 0});

  @override
  State<ResponsiveNavigation> createState() => _ResponsiveNavigationState();
}

class _ResponsiveNavigationState extends State<ResponsiveNavigation> {
  int selectedIndex = 0;

  final List<AppDestination> appDestinations = [
    AppDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      page: HomeScreen(),
    ),
    AppDestination(
      label: 'Create',
      icon: Icons.add_outlined,
      selectedIcon: Icons.add,
      page: CreateScreen(),
    ),
    AppDestination(
      label: 'Search',
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      page: SearchScreen(),
    ),
   
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.intialIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.isDesktop(context)) {
      return _buildDesktopLayout();
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            selectedIndex: selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: appDestinations.map(_buildRailDestination).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildNestedNavigator()),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: appDestinations.map(_buildRailDestination).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildNestedNavigator()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: _buildNestedNavigator(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: appDestinations.map(_buildBottomDestination).toList(),
      ),
    );
  }

  NavigationRailDestination _buildRailDestination(AppDestination dest) {
    return NavigationRailDestination(
      icon: Icon(dest.icon),
      selectedIcon: Icon(dest.selectedIcon),
      label: Text(dest.label),
    );
  }

  NavigationDestination _buildBottomDestination(AppDestination dest) {
    return NavigationDestination(
      icon: Icon(dest.icon),
      selectedIcon: Icon(dest.selectedIcon),
      label: dest.label,
    );
  }

  void _onDestinationSelected(int index) {
    if (index != selectedIndex) {
      setState(() {
        selectedIndex = index;
      });
      // // Optional: Update top-level route so URL reflects tab change
   
    }
  }

  String _routeForIndex(int index) {
    switch (index) {
      case 1:
        return RouteGenerator.home;
      case 2:
        return RouteGenerator.create;
      case 3:
        return RouteGenerator.search;
      // case 4:
      //   return RouteGenerator.home;
      // case 5:
      //   return RouteGenerator.cart;
      case 0:
      default:
        return RouteGenerator.initial;
    }
  }

  Widget _buildNestedNavigator() {
    return Navigator(
      key: ValueKey<int>(selectedIndex), // keep state per tab
      onGenerateRoute: (RouteSettings settings) {
        // Return the page matching selectedIndex
        return MaterialPageRoute(
          builder: (context) => appDestinations[selectedIndex].page,
        );
      },
    );
  }
}





/// Custom data class – renamed to avoid conflict with Flutter's NavigationDestination
class AppDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}