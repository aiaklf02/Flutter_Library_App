import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class Empreinte {
  final int? empreinteId;
  final int bookId;
  final String empreinte;
  final DateTime dateEmpreinte;

  Empreinte({this.empreinteId, required this.bookId, required this.empreinte, required this.dateEmpreinte});

  Map<String, dynamic> toMap() {
    return {
      'empreinteId': empreinteId,
      'bookId': bookId,
      'empreinte': empreinte,
      'dateEmpreinte': dateEmpreinte.toIso8601String(),
    };
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE Empreintes (
        empreinteId INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER,
        empreinte TEXT,
        dateEmpreinte TEXT
      )
    ''');
  }

  static Future<void> insertEmpreinte(Database db, Empreinte empreinte) async {
    await db.insert(
      'Empreintes',
      empreinte.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Empreinte>> getEmpreintesForBook(Database db, int bookId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'Empreintes',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );

    return List.generate(maps.length, (i) {
      return Empreinte(
        empreinteId: maps[i]['empreinteId'],
        bookId: maps[i]['bookId'],
        empreinte: maps[i]['empreinte'],
        dateEmpreinte: DateTime.parse(maps[i]['dateEmpreinte']),
      );
    });
  }
}
