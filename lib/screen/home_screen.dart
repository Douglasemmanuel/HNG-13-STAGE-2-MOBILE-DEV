import 'package:flutter/material.dart';
import 'package:store_keeper_app/models/store_models.dart';
import 'package:store_keeper_app/utils/route_generator.dart';
import 'package:store_keeper_app/utils/responsive_breakpoints.dart';
import 'package:store_keeper_app/services/database_provider.dart' ;
import 'package:store_keeper_app/widgets/component/Single_product_card.dart' ;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              _buildHeroSection(context),
              SizedBox(height: 10.0,),
              Expanded(
      child: _buildAllProducts(),
    ),
          ],
        ),
      ),
    );
  }

    Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: ResponsiveBreakpoints.isMobile(context) ? 200 : 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
      Color(0xFF1E3A8A), 
      Color(0xFF2563EB), 
    ],
         
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                      Text(
            'Hi 👋, StoreKeeper’s got your Products covered.',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20, 
                  height: 1.2,
                  letterSpacing: 1,
                ),
          ),
            const SizedBox(height: 8),
            Text(
              'Discover amazing Products with their prices',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _exploreProducts(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF1E3A8A),
              ),
              child: const Text('Explore Products'),
            ),
          ],
        ),
      ),
    );
  }


Widget _buildAllProducts() {
  return FutureBuilder<List<Product>>(
    future: ProductServices().getAllProducts(), 
    builder: (context, snapShot) {
      if (snapShot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapShot.hasError) {
        return Center(child: Text('Error: ${snapShot.error}'));
      } else if (!snapShot.hasData || snapShot.data!.isEmpty) {
        return const Center(child: Text('No products available'));
      }

      final products = snapShot.data!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Products',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => _viewAllProducts(context),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
         
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SingleProductCard(
                    image: product.image, 
                    productName: product.productName,
                    price: product.price,
                    quantity: product.quantity,
                    productId: product.id.toString(),
                    isLast: index == products.length - 1,
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

}




 void _exploreProducts(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(RouteGenerator.all);
  }

  void _viewAllProducts(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(RouteGenerator.all);
  }