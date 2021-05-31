library simple_database;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class SimpleDatabase {
  ///The name of the file for localstorage
  final String name;

  ///Optional function used to rebuild user defined objects
  final Function(Map<String, dynamic>)? fromJson;

  ///Requires a name and an optional function used to rebuild from json
  SimpleDatabase({
    required this.name,
    this.fromJson,
  });

  ///Private function for writing a list to json
  Future<void> _saveList(List<dynamic> objList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, json.encode(objList).toString());
  }

  ///The amount of items in the database
  Future<int> count() async {
    return (await this.getAll()).length;
  }

  ///A list of dynamic which contains all objects in the database
  Future<List<dynamic>> getAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(name) == null) return [];

    String? jsonString = prefs.getString(name);

    if (jsonString == null) return [];

    List<dynamic>? mapList = json.decode(jsonString);
    List<dynamic> objList = [];

    if (mapList == null) return [];

    for (dynamic object in mapList) {
      //Attempt to use the user provided fromJson function to rebuild an object
      try {
        objList.add(fromJson!(object));
      } catch (error) {
        objList.add(object);
      }
    }

    return objList;
  }

  ///The object stored at an idex
  Future<dynamic> getAt(int index) async {
    List<dynamic> list = await getAll();

    if (list.length <= index) return null;

    return list[index];
  }

  ///Overrite the current data with the passed list
  Future<void> saveList(List<dynamic> list) async {
    await _saveList(list);
  }

  ///Add a list of objects into the database
  Future<void> addAll(List<dynamic> list) async {
    List<dynamic> current = await getAll();

    for (dynamic item in list) {
      current.add(item);
    }

    await _saveList(current);
  }

  ///Insert object at an index
  Future<void> insert(dynamic object, int index) async {
    List<dynamic> list = await getAll();

    list.insert(index, object);

    await _saveList(list);
  }

  ///Delete all objects from the database
  Future<void> clear() async {
    await _saveList([]);
  }

  ///Delete an object at an index
  Future<void> removeAt(int index) async {
    List<dynamic> list = await getAll();

    if (index >= list.length) return;

    list.removeAt(index);

    await _saveList(list);
  }

  ///Delete the first instance of an object
  Future<bool> remove(dynamic object) async {
    List<dynamic> objects = await getAll();
    List<dynamic> newList = [];

    for (dynamic obj in objects) {
      if (obj != object) newList.add(obj);
    }

    await _saveList(newList);

    if (newList.length != objects.length) return true;
    return false;
  }

  ///Bool if the database contains an object
  Future<bool> contains(dynamic object) async {
    List<dynamic> objects = await getAll();

    for (dynamic obj in objects) {
      if (object == obj) {
        return true;
      }
    }

    return false;
  }

  ///Add an object into the database
  Future<void> add(dynamic object) async {
    List<dynamic> objList = await this.getAll();
    objList.add(object);
    await _saveList(objList);
  }

  //Get specific type at in index
  Future<T> getAtType<T>(int index) async {
    List<dynamic> list = await getAll();

    assert(index < list.length, true);
    assert(list.length != 0);
    //assert(index < 0, false);

    return list[index];
  }

  //Get a list of all objects of a type from the database
  Future<List<T>> getAllType<T>() async {
    List<dynamic> dynamicList = await getAll();

    List<T> list = [];

    for (dynamic object in dynamicList) {
      try {
        list.add(object);
      } catch (error) {}
    }

    return list;
  }
}
