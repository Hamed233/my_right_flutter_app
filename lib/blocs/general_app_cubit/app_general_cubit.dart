import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_right/components/constatnts.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/helpers/database_helper.dart';
import 'package:my_right/helpers/database_helper.dart';
import 'package:my_right/layout/auth/login/login_screen.dart';
import 'package:my_right/layout/home_screen.dart';
import 'package:my_right/local/cache_helper.dart';
import 'package:my_right/models/client_model.dart';
import 'package:my_right/models/installment_model.dart';
import 'package:my_right/models/user_model.dart';
import 'package:my_right/utiles/helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../layout/layout_of_app.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(ChangePasswordVisibilityState());
  }

  double? totalPrice = 0.0;
  double? payedPrice = 0.0;
  double? leftPrice = 0.0;

  void getTotalPrice(_totalPrice) {
    totalPrice = double.parse(_totalPrice).toDouble();
    emit(GetTotalPriceState());
  }

  void getPayedPrice(_payedPrice) {
    payedPrice = double.parse(_payedPrice).toDouble();
    emit(GetTotalPriceState());
  }

  void getCalcLeftPrice() {
    leftPrice = totalPrice! - payedPrice!;
    emit(CalcLeftPriceState());
  }

  // Get Date of Task
  final DateTime today = DateTime.now();
  late String startDate = DateFormat('dd, MMMM yyyy').format(today).toString(),
      endDate = DateFormat('dd, MMMM yyyy').format(today).toString();
  late String? currentTime = DateFormat('hh:mm a').format(today).toString();

  Future<List<Map<String, dynamic>>> getClientsList() async {
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM  ${DatabaseHelper.instance.clientsTable} WHERE userId = $userId ORDER BY id DESC");
    return result;
  }

  List<Client> clients = [];
  // Get All clients
  Future getclients(context) async {
    final List<Map<String, dynamic>> clientsMapList = await getClientsList();
    clients = [];

    emit(GettingClientsLoading());

    clientsMapList.forEach((clientMap) {
      clients.add(Client.fromMap(clientMap));
    });

    print(clients);

    emit(GettingClientsDone());
  }

  Future<List<Map<String, dynamic>>> getInstallmentsList(clientId) async {
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM  ${DatabaseHelper.instance.installmentsTable} WHERE client_id = $clientId");
    return result;
  }

  List<Installment> installments = [];
  // Get All installments
  Future getInstallments(context, clientId) async {
    final List<Map<String, dynamic>> installmentsMapList =
        await getInstallmentsList(clientId);
    installments = [];

    emit(GettingInstallmentsLoading());
    print(installmentsMapList);

    installmentsMapList.forEach((installmentsMap) {
      installments.add(Installment.fromMap(installmentsMap));
    });

    print(installments);

    emit(GettingInstallmentsDone());
  }

  List<Client> clientData = [];
  // Get Client Data
  Future getClientData(clientId) async {
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> clientDataMapList = await db.rawQuery(
        "SELECT * FROM  ${DatabaseHelper.instance.clientsTable} WHERE id = $clientId");
    clientData = [];

    emit(GettingClientDataLoading());

    print(clientDataMapList);
    clientDataMapList.forEach((dataMap) {
      clientData.add(Client.fromMap(dataMap));
    });

    emit(GettinClientDataDone());
  }

  Future updateClientData(left_price, payed_price, clientId) async {
    emit(GettingClientDataLoading());
    Database db = await DatabaseHelper.instance.db;
    final int updateRow = await db.rawUpdate(
        "UPDATE ${DatabaseHelper.instance.clientsTable} SET left_price = ?, payed_price = ? WHERE id = ?",
        [left_price, payed_price, clientId]);
    if (updateRow > 0) {
      emit(UpdateClientDataSuccessfully());
    } else {
      emit(UpdateClientDataFailer());
    }
  }

  Future<List<Map<String, dynamic>>> getUsersList() async {
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> result =
        await db.query(DatabaseHelper.instance.usersTable, orderBy: "id DESC");
    return result;
  }

  List<User> users = [];
  // Get All users
  Future getUsers() async {
    final List<Map<String, dynamic>> usersMapList = await getUsersList();
    clients = [];

    emit(GettingUsersLoading());

    usersMapList.forEach((userMap) {
      users.add(User.fromMap(userMap));
    });

    print(users);

    emit(GettinUsersDone());
  }

  void createUser(
    context, {
    required String name,
    required String email,
    required String password,
  }) {
    User model = User(
      username: name,
      email: email,
      password: password,
      date: DateTime.now().toIso8601String(),
    );

    DatabaseHelper.instance
        .insertDataToTable(context, user: model)
        .then((value) {
      emit(AppRegisterSuccessState());
    }).catchError((error) {
      emit(AppRegisterErrorState(error.toString()));
      print(error.toString());
    });
  }

  User? userModel;

  void userLogin({
    required String username,
    required String password,
  }) async {
    emit(AppLoginLoadingState());
    Database db = await DatabaseHelper.instance.db;
    var res = await db.rawQuery(
        "SELECT * FROM users_tbl WHERE username = '$username' and password = '$password'");
    print(res.length);
    if (res.isNotEmpty) {
      userModel = User.fromMap(res.first);
      emit(AppLoginSuccessState(userModel!.id!.toString()));
    } else {
      emit(AppLoginErrorState("user not exist"));
    }
  }

  List<Client> searchList = [];
  // Search Clients
  Future search(String text) async {
    emit(SearchClientLoadingState());

    Database db = await DatabaseHelper.instance.db;
    db.rawQuery('SELECT * FROM clients_tbl WHERE name LIKE ? OR product LIKE ?',
        ['%$text%', '%$text%']).then((value) {
      emit(SearchClientSuccessState());
      searchList = [];
      value.forEach((element) {
        searchList.add(Client.fromMap(element));
      });
      emit(RetrieveClientDataFromDatabase());
    }).catchError((error) {
      print(error.toString());
      emit(SearchClientErrorState());
    });
  }

  Future signOut(context) async {
    emit(SignoutLoading());
    CacheHelper.removeData(
      key: 'user_id',
    ).then((value) async {
      Helper.showCustomSnackBar(context,
          content: "تم تسجيل الخروج بنجاح",
          bgColor: Colors.green,
          textColor: Colors.white);
      navigateAndFinish(
        context,
        LoginScreen(),
      );
    });

    emit(SignoutSuccessful());
  }
}
