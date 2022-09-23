import 'dart:convert';
import 'package:flutter/material.dart';


class User {
  int? id;
  String? username;
  String? email;
  String? password;
  String? date;

  User({
    this.username,
    this.email,
    this.password,
    this.date,
  });

  User.withId({
    this.id,
    this.username,
    this.email,
    this.password,
    this.date,
  });

    Map<String, dynamic> toMap() {
      final map = Map<String, dynamic>();
      map['id'] = id;
      map['username'] = username;
      map['email'] = email;
      map['password'] = password;
      map['date'] = date;
      return map;
    }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.withId(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      date: map['date'],
    );
  }

}