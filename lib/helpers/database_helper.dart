import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:my_right/models/client_model.dart';
import 'package:my_right/models/installment_model.dart';
import 'package:my_right/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _db;

  // Users Table
  String usersTable = 'users_tbl';
  String colId = 'id';
  String colUsername = 'username';
  String colEmail = 'email';
  String colPassword = 'password';
  String colDate = 'date';

  // Clients Table
  String clientsTable = 'clients_tbl';
  String colClientId = 'id';
  String colClientName = 'name';
  String colClientProduct = 'product';
  String colClientTotalPrice = 'total_price';
  String colClientPayedPrice = 'payed_price';
  String colClientLeftPrice = 'left_price';
  String colClientEntryDate = 'entry_date';
  String colUserId = 'userId';

  // Installments Table
  String installmentsTable = 'installments_tbl';
  String colInstallmentId = 'id';
  String colInstallmentPrice = 'price';
  String colInstallmentClientId = 'client_id';
  String colInstallmentEntryDate = 'entry_date';

  Future<Database> get db async {
    _db = await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'my___Right_app.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $usersTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colUsername TEXT, $colEmail TEXT, $colPassword TEXT, $colDate TEXT)');
    await db.execute(
        'CREATE TABLE $clientsTable ($colClientId INTEGER PRIMARY KEY AUTOINCREMENT, $colClientName TEXT, $colClientProduct TEXT, $colClientTotalPrice TEXT, $colClientPayedPrice TEXT, $colClientLeftPrice TEXT, $colClientEntryDate TEXT, $colUserId INTEGER)');
    await db.execute(
        'CREATE TABLE $installmentsTable ($colInstallmentId INTEGER PRIMARY KEY AUTOINCREMENT, $colInstallmentPrice INTEGER, $colInstallmentClientId INTEGER, $colInstallmentEntryDate TEXT)');
  }

  // --------------- Tasks ---------------
  Future<int> insertDataToTable(context,
      {User? user, Client? client, Installment? installment}) async {
    Database db = await this.db;
    if (user != null) {
      final int result = await db.insert(usersTable, user.toMap());
      return result;
    } else if (client != null) {
      await db.insert(clientsTable, client.toMap()).then((value) {
        db.rawQuery("SELECT max(id) FROM $clientsTable").then((value) {
          Installment installment = Installment(
            price: int.parse(client.payed_price!),
            entry_date:
                DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString(),
            client_id: int.parse(value.last.values.first.toString()),
          );

          insertDataToTable(context, installment: installment);
        });
      });

    } else if (installment != null) {
      final int result =
          await db.insert(installmentsTable, installment.toMap());
      return result;
    }

    return 0;
  }

  Future<int> updateTable({User? user, Client? client}) async {
    Database db = await this.db;
    if (user != null) {
      final int result = await db.update(usersTable, user.toMap(),
          where: '$colId = ?', whereArgs: [user.id]);
      return result;
    } else if (client != null) {
      final int result = await db.update(clientsTable, client.toMap(),
          where: '$colClientId = ?', whereArgs: [client.id]);
      print(result);
      return result;
    }

    return 0;
  }

  Future<int> deleteFromTable(String? table, int? id) async {
    Database db = await this.db;
    if (table == 'users') {
      final int result =
          await db.delete(usersTable, where: colId = '?', whereArgs: [id]);
      return result;
    } else if (table == 'clients') {
      final int result =
          await db.rawDelete('DELETE FROM $clientsTable WHERE id = ?', [id]);
      return result;
    } else if (table == 'installments') {
      final int result = await db.rawDelete(
          'DELETE FROM $installmentsTable WHERE client_id = ?', [id]);
      return result;
    }

    return 0;
  }
}
