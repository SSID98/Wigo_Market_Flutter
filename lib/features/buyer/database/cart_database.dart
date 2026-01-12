import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wigo_flutter/features/buyer/models/cart_model.dart';

class CartDatabase {
  static final CartDatabase instance = CartDatabase._init();
  static Database? _database;

  CartDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        productName TEXT PRIMARY KEY,
        price REAL NOT NULL,
        imageUrl TEXT NOT NULL,
        stock INTEGER NOT NULL,
        colorName TEXT NOT NULL,
        size TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        isOrdered INTEGER NOT NULL,
        saveInfo INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertItem(CartState item) async {
    final db = await instance.database;
    await db.insert(
      'cart_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartState>> getAllItems() async {
    final db = await instance.database;
    final result = await db.query('cart_items');
    return result.map((json) => CartState.fromMap(json)).toList();
  }

  Future<void> deleteItem(String productName) async {
    final db = await instance.database;
    await db.delete(
      'cart_items',
      where: 'productName = ?',
      whereArgs: [productName],
    );
  }

  Future<void> clearCart() async {
    final db = await instance.database;
    await db.delete('cart_items');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
