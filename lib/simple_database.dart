library simple_database;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class SimpleDatabase<T> {
  final String name;

  SimpleDatabase({@required this.name});

  Future<void> _saveList(List<T> objList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(json.encode(objList).toString());
    prefs.setString(name, json.encode(objList).toString());
  }

  Future<List<T>> getAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(name) == null) return List<T>();

    List<dynamic> mapList = json.decode(prefs.getString(name));
    List<T> objList = List<T>();

    for (dynamic object in mapList) {
      objList.add(object);
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
