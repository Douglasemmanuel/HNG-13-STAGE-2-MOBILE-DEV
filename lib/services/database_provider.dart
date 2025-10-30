import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:store_keeper_app/models/store_models.dart';


class ProductServices {
  static final ProductServices _instance = ProductServices._init();
  ProductServices._init();
  static Database? _db;
  factory ProductServices() => _instance;
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'store_inventory.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id TEXT PRIMARY KEY,
            name TEXT,
            price REAL,
            quantity INTEGER,
            category TEXT,
            image TEXT,
            createdAt TEXT
          )
        ''');
      },
    );
  }
 Future<void> addProduct(Product product) async {
  final db = await database;
  try {
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e, stack) {
    print('Error inserting product: $e');
    print(stack);
  }
}


Future<void> updateProduct(Product product) async {
  final db = await database;
  await db.update(
    'products',
    product.toMap(), // ✅ changed here
    where: 'id = ?',
    whereArgs: [product.id],
  );
}

Future<List<Product>> getAllProducts() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('products');
  return List.generate(maps.length, (i) => Product.fromMap(maps[i])); // ✅ changed here
}

Future<Product?> getSingleProduct(String id) async {
  final db = await database;
  final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
  if (result.isNotEmpty) return Product.fromMap(result.first); // ✅ changed here
  return null;
}

Future<List<Product>> searchProduct(String query) async {
  final db = await database;
  final List<Map<String, dynamic>> result = await db.query(
    'products',
    where: 'LOWER(name) LIKE ?',
    whereArgs: ['%${query.toLowerCase()}%'],
  );
  return result.map((e) => Product.fromMap(e)).toList(); // ✅ changed here
}

Future<List<Product>> filterProduct(String category) async {
  final db = await database;
  if (category == 'all') return getAllProducts();
  final result = await db.query(
    'products',
    where: 'category = ?',
    whereArgs: [category],
  );
  return result.map((e) => Product.fromMap(e)).toList(); // ✅ changed here
}

 Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
