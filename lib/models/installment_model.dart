import 'dart:convert';
import 'package:flutter/material.dart';


class Installment {
  int? id;
  int? price;
  int? client_id;
  String? entry_date;

  Installment({
    this.price,
    this.client_id,
    this.entry_date,
  });

  Installment.withId({
    this.id,
    this.price,
    this.client_id,
    this.entry_date,
  });

    Map<String, dynamic> toMap() {
      final map = Map<String, dynamic>();
      map['id'] = id;
      map['price'] = price;
      map['client_id'] = client_id;
      map['entry_date'] = entry_date;
      return map;
    }

  factory Installment.fromMap(Map<String, dynamic> map) {
    return Installment.withId(
      id: map['id'],
      price: map['price'],
      client_id: map['client_id'],
      entry_date: map['entry_date'],
    );
  }

}