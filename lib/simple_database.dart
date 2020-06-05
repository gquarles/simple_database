library simple_database;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class SimpleDatabase {
  final String name;
  final Function(Map<String, dynamic>) fromJson;

  SimpleDatabase({
    @required this.name,
    this.fromJson,
  });

  Future<void> _saveList(List<dynamic> objList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, json.encode(objList).toString());
  }

  Future<int> count() async {
    return (await this.getAll()).length;
  }

  Future<List<dynamic>> getAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(name) == null) return List<dynamic>();

    List<dynamic> mapList = json.decode(prefs.getString(name));
    List<dynamic> objList = List<dynamic>();

    if (fromJson == null) {
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

  Future<dynamic> getAt(int index) async {
    List<dynamic> list = await getAll();

    if (list.length <= index) return null;

    return list[index];
  }

  Future<void> saveList(List<dynamic> list) async {
    await _saveList(list);
  }

  Future<void> addAll(List<dynamic> list) async {
    List<dynamic> current = await getAll();

    for (dynamic item in list) {
      current.add(item);
    }

    await _saveList(current);
  }

  Future<void> insert(dynamic object, int index) async {
    List<dynamic> list = await getAll();

    list.insert(index, object);

    _saveList(list);
  }

  Future<void> clear() async {
    await _saveList(List<dynamic>());
  }

  Future<void> removeAt(int index) async {
    List<dynamic> list = await getAll();

    if (index >= list.length) return;

    list.removeAt(index);

    await _saveList(list);
  }

  Future<bool> remove(dynamic object) async {
    List<dynamic> objects = await getAll();
    List<dynamic> newList = List<dynamic>();

    for (dynamic obj in objects) {
      if (obj != object) newList.add(obj);
    }

    await _saveList(newList);
    
    if (newList.length != objects.length) return true;
    return false;
  }

  Future<bool> contains(dynamic object) async {
    List<dynamic> objects = await getAll();

    for (dynamic obj in objects) {
      if (object == obj) {
        return true;
      }
    }

    return false;
  }

  Future<void> add(dynamic object) async {
    List<dynamic> objList = await this.getAll();
    objList.add(object);
    await _saveList(objList);
  }
}