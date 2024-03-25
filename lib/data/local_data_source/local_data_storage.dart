import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


import '../../Model/marker_model.dart';

class MarkerDatabaseHelper {
  static final MarkerDatabaseHelper instance = MarkerDatabaseHelper._init();
  static Database? _database;

  MarkerDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('markers.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE markers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        markerId TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL
      )
    ''');
  }

  Future<MarkerModel> createMarker(MarkerModel marker) async {
    final db = await instance.database;
    final id = await db.insert('markers', marker.toMap());
    return marker.copyWith(id: id);
  }

  Future<List<MarkerModel>> fetchMarkers() async {
    final db = await instance.database;
    debugPrint("fetchMarkers");
    final maps = await db.query('markers');
    return List.generate(maps.length, (i) {
      return MarkerModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteMarker(int id) async {
    final db = await instance.database;
    await db.delete(
      'markers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
    Future<void> clearMarkers() async {
    final db = await instance.database;
    await db.delete('markers');
  }
}
