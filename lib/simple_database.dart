library simple_database;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class SimpleDatabase<T> {
  final String name;
  final Function(Map<String, dynamic>) fromJson;

  SimpleDatabase({
    @required this.name,
    this.fromJson,
  });

  Future<void> _saveList(List<T> objList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, json.encode(objList).toString());
  }

  Future<int> count() async {
    return (await this.getAll()).length;
  }

  Future<List<T>> getAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(name) == null) return List<T>();

    List<dynamic> mapList = json.decode(prefs.getString(name));
    List<T> objList = List<T>();

    var type = (T).toString();

    if (type == 'int' ||
        type == 'double' ||
        type == 'bool' ||
        type == 'String') {
      for (dynamic object in mapList) {
        objList.add(object);
      }
    } else {
      for (dynamic object in mapList) {
        objList.add(fromJson(object));
      }
    }

    return objList;
  }

  Future<void> clear() async {
    await _saveList(List<T>());
  }

  Future<void> add(T object) async {
    List<T> objList = await this.getAll();
    objList.add(object);
    _saveList(objList);
  }
}
