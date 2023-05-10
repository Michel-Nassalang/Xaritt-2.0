
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/composants/Chat.dart';
import '../models/composants/Chatlist.dart';
import '../models/composants/Dtext.dart';
import '../models/composants/Rtext.dart';
import '../models/composants/Ttext.dart';
class IaDatabase {
  IaDatabase._privateConstructor();
  
  static final IaDatabase instance = IaDatabase._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'xaritt.db'),
      // ignore: void_checks
      onCreate: (db, version) {
        return {
          db.execute(
            '''CREATE TABLE Chatlist(
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              title TEXT, 
              date TEXT)'''
          ),
          db.execute(
            '''CREATE TABLE Chat(
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              msg TEXT, 
              chatIndex INTEGER, 
              idChatlist INTEGER, 
              date TEXT)'''
          ),
          db.execute(
            '''CREATE TABLE Rtext(
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              text TEXT, 
              date TEXT)'''
          ),
          db.execute(
            '''CREATE TABLE Dtext(
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              text TEXT, 
              date TEXT)'''
          ),
          db.execute(
            '''CREATE TABLE Ttext(
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              text TEXT,  
              ttext TEXT, 
              date TEXT)'''
          )
        };
      },
      version: 1,
    );
  }

  //-----------------------Chatlist-----------------------------------

  void insertChatlist(String title) async {
    final Database? db = await database;
    var valeur = {'title': title, 'date': DateTime.now().toIso8601String()};
    await db!.insert(
      'chatlist',
      valeur,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateChatlist(String text, Chatlist chatlist) async {
    final Database? db = await database;
    var valeur = {'title': text, 'date': DateTime.now().toIso8601String()};
    await db!.update('Chatlist', valeur, where: 'id = ?', whereArgs: [chatlist.id]);
  }

  void deleteChatlist(int id) async {
    final Database? db = await database;
    await db!.delete('Chatlist', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Chatlist>> chatlists() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM Chatlist ORDER BY id DESC');
    List<Chatlist> chatlists = List.generate(maps.length, (i) {
      return Chatlist.fromMap(maps[i]);
    });
    if (chatlists.isEmpty) {}
    return chatlists;
  }

  Future<List<Chatlist>> rechercheChatlist(String mot) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM Chatlist WHERE title LIKE ? ORDER BY id DESC', ['%$mot%']);
    List<Chatlist> chatlists = List.generate(maps.length, (i) {
      return Chatlist.fromMap(maps[i]);
    });
    if (chatlists.isEmpty) {}
    return chatlists;
  }

  //-----------------------Fin Chatlist-------------------------------

  //-----------------------Chat-----------------------------------

  void insertChat(
      String msg, int chatIndex, int idChatlist) async {
    final Database? db = await database;
    var valeur = {
      'msg': msg,
      'chatIndex': chatIndex,
      'idChatlist': idChatlist,
      'date': DateTime.now().toIso8601String()
    };
    await db!.insert(
      'Chat',
      valeur,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateChat(
      String msg, int chatIndex, int idChatlist, Chat chat) async {
    final Database? db = await database;
    var valeur = {'msg': msg, 'chatIndex': chatIndex, 'idChatlist': idChatlist};
    await db!.update('Chat', valeur,
        where: 'id = ?', whereArgs: [chat.id]);
  }

  void deleteChat(int id) async {
    final Database? db = await database;
    await db!.delete('Chat', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Chat>> chats() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM Chat ORDER BY id DESC');
    List<Chat> chats = List.generate(maps.length, (i) {
      return Chat.fromMap(maps[i]);
    });
    if (chats.isEmpty) {}
    return chats;
  }

  Future<List<Chat>> chatByChatlist(int idChatlist) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM Chat WHERE idChatlist = $idChatlist ORDER BY id DESC');
    List<Chat> chats = List.generate(maps.length, (i) {
      return Chat.fromMap(maps[i]);
    });
    if (chats.isEmpty) {}
    return chats;
  }

  Future<List<Chat>> rechercheChat(String mot) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM Chat WHERE msg LIKE ? ORDER BY id DESC',
        ['%$mot%']);
    List<Chat> chats = List.generate(maps.length, (i) {
      return Chat.fromMap(maps[i]);
    });
    if (chats.isEmpty) {}
    return chats;
  }

  //-----------------------Fin Chat-----------------------------------

  
  //-----------------------Detection Text-----------------------------------

  void insertDtext(String text) async {
    final Database? db = await database;
    var valeur = {
      'text': text,
      'date': DateTime.now().toIso8601String()
    };
    await db!.insert(
      'Dtext',
      valeur,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateDtext(String text, Dtext dtext) async {
    final Database? db = await database;
    var valeur = {'text': text, 'date': DateTime.now().toIso8601String()};
    await db!.update('Dtext', valeur, where: 'id = ?', whereArgs: [dtext.id]);
  }

  void deleteDtext(int id) async {
    final Database? db = await database;
    await db!.delete('Dtext', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Dtext>> dtexts() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM Dtext ORDER BY id DESC');
    List<Dtext> dtexts = List.generate(maps.length, (i) {
      return Dtext.fromMap(maps[i]);
    });
    if (dtexts.isEmpty) {}
    return dtexts;
  }


  Future<List<Dtext>> rechercheDtext(String mot) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM Dtext WHERE text LIKE ? ORDER BY id DESC', ['%$mot%']);
    List<Dtext> dtexts = List.generate(maps.length, (i) {
      return Dtext.fromMap(maps[i]);
    });
    if (dtexts.isEmpty) {}
    return dtexts;
  }

  //-----------------------Fin Detection Text-------------------------------

  //-----------------------Translation Text-----------------------------------

  void insertTtext(String text, String ttexte) async {
    final Database? db = await database;
    var valeur = {'text': text, 'ttext':ttexte, 'date': DateTime.now().toIso8601String()};
    await db!.insert(
      'Ttext',
      valeur,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateTtext(String text, String ttexte, Ttext ttext) async {
    final Database? db = await database;
    var valeur = {'text': text, 'ttext':ttexte, 'date': DateTime.now().toIso8601String()};
    await db!.update('Ttext', valeur, where: 'id = ?', whereArgs: [ttext.id]);
  }

  void deleteTtext(int id) async {
    final Database? db = await database;
    await db!.delete('Ttext', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Ttext>> ttexts() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM ttext ORDER BY id DESC');
    List<Ttext> dtexts = List.generate(maps.length, (i) {
      return Ttext.fromMap(maps[i]);
    });
    if (dtexts.isEmpty) {}
    return dtexts;
  }

  Future<List<Ttext>> rechercheTtext(String mot) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM Ttext WHERE text LIKE ? ORDER BY id DESC', ['%$mot%']);
    List<Ttext> dtexts = List.generate(maps.length, (i) {
      return Ttext.fromMap(maps[i]);
    });
    if (dtexts.isEmpty) {}
    return dtexts;
  }

  //-----------------------Fin Translation Text-------------------------------

  //-----------------------Recognition Text-----------------------------------

  void insertRtext(String text) async {
    final Database? db = await database;
    var valeur = {'text': text, 'date': DateTime.now().toIso8601String()};
    await db!.insert(
      'Rtext',
      valeur,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateRtext(String text, Rtext rtext) async {
    final Database? db = await database;
    var valeur = {'text': text, 'date': DateTime.now().toIso8601String()};
    await db!.update('Rtext', valeur, where: 'id = ?', whereArgs: [rtext.id]);
  }

  void deleteRtext(int id) async {
    final Database? db = await database;
    await db!.delete('Rtext', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Rtext>> rtexts() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM Rtext ORDER BY id DESC');
    List<Rtext> rtexts = List.generate(maps.length, (i) {
      return Rtext.fromMap(maps[i]);
    });
    if (rtexts.isEmpty) {}
    return rtexts;
  }

  Future<List<Rtext>> rechercheRtext(String mot) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM Rtext WHERE text LIKE ? ORDER BY id DESC', ['%$mot%']);
    List<Rtext> rtexts = List.generate(maps.length, (i) {
      return Rtext.fromMap(maps[i]);
    });
    if (rtexts.isEmpty) {}
    return rtexts;
  }

  //-----------------------Fin Recognition Text-------------------------------

}