import 'dart:convert';
import 'package:flutter/material.dart';


class Client {
  int? id;
  String? name;
  String? product;
  String? total_price;
  String? payed_price;
  String? left_price;
  String? entry_date;
  int? userId;

  Client({
    this.name,
    this.product,
    this.total_price,
    this.payed_price,
    this.left_price,
    this.entry_date,
    this.userId,
  });

  Client.withId({
    this.id,
    this.name,
    this.product,
    this.total_price,
    this.payed_price,
    this.left_price,
    this.entry_date,
    this.userId,
  });

    Map<String, dynamic> toMap() {
      final map = Map<String, dynamic>();
      map['id'] = id;
      map['name'] = name;
      map['product'] = product;
      map['total_price'] = total_price;
      map['payed_price'] = payed_price;
      map['left_price'] = left_price;
      map['entry_date'] = entry_date;
      map['userId'] = userId;
      return map;
    }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client.withId(
      id: map['id'],
      name: map['name'],
      product: map['product'],
      total_price: map['total_price'],
      payed_price: map['payed_price'],
      left_price: map['left_price'],
      entry_date: map['entry_date'],
      userId: map['userId'],
    );
  }

}