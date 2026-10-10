import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'Amazon.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productName TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            isFavorite INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  static Future<int> insertProduct({
    required String productName,
    required int quantity,
    required double price,
    bool isFavorite = false,
  }) async {
    final db = await database;
    return await db.insert(
      'products',
      {
        'productName': productName,
        'quantity': quantity,
        'price': price,
        'isFavorite': isFavorite ? 1 : 0,
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query('products', orderBy: 'id DESC');
  }

  static Future<List<Map<String, dynamic>>> searchProducts(String text) async {
    final db = await database;
    return await db.query(
      'products',
      where: 'productName LIKE ?',
      whereArgs: ['%$text%'],
    );
  }

  static Future<int> updateProduct({
    required int id,
    required String productName,
    required int quantity,
    required double price,
    required bool isFavorite,
  }) async {
    final db = await database;
    return await db.update(
      'products',
      {
        'productName': productName,
        'quantity': quantity,
        'price': price,
        'isFavorite': isFavorite ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'products',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}