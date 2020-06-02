import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_database/simple_database.dart';

class SimpleClass {
  final int age;
  final String name;
  final double height;
  final bool gender;

  SimpleClass(this.age, this.name, this.height, this.gender);

  SimpleClass.fromJson(Map<String, dynamic> json) : age = json['age'], name = json['name'], height = json['height'], gender = json['gender'];

  static SimpleClass create(Map<String, dynamic> json) {
    return SimpleClass.fromJson(json);
  }

  Map<String, dynamic> toJson() => {
    'age': age,
    'name' : name,
    'height' : height,
    'gender' : gender,
  };
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('int', () async {
    SimpleDatabase intDB = SimpleDatabase(name: 'int');

    List<dynamic> intList = await intDB.getAll();

    expect(intList.length, 0);

    await intDB.add(121);

    intList = await intDB.getAll();

    expect(intList[0] + 5, 126);
    expect(intList.length, 1);
    expect(intList[0], 121);

    await intDB.clear();

    intList = await intDB.getAll();

    expect(intList.length, 0);

    await intDB.add(10);
    await intDB.add(15);
    await intDB.add(20);

    intList = await intDB.getAll();

    int count = await intDB.count();

    expect(count, 3);
    expect(intList.length, 3);

    expect(intList[0], 10);
    expect(intList[1], 15);
    expect(intList[2], 20);

    expect(intList[0] + intList[1] + intList[2], 45);
  });

  test('string', () async {
    SimpleDatabase stringDB = SimpleDatabase(name: 'string');

    List<dynamic> stringList = await stringDB.getAll();

    expect(stringList.length, 0);

    await stringDB.add('Hello, World!');

    stringList = await stringDB.getAll();

    expect(stringList.length, 1);
    expect(stringList[0], 'Hello, World!');

    await stringDB.add('Simple Database!');

    stringList = await stringDB.getAll();

    expect(stringList[1], 'Simple Database!');

    expect('${stringList[0]} ${stringList[1]}', 'Hello, World! Simple Database!');
  });

  test('bool', () async {
    SimpleDatabase boolDB = SimpleDatabase(name: 'bool');

    List<dynamic> boolList = await boolDB.getAll();

    expect(boolList.length, 0);

    await boolDB.add(true);
    
    boolList = await boolDB.getAll();

    expect(boolList.length, 1);
    expect(boolList[0], true);

    await boolDB.add(true);
    await boolDB.add(false);

    boolList = await boolDB.getAll();

    expect(boolList[0], true);
    expect(boolList[1], true);
    expect(boolList[2], false);
    expect(boolList.length, 3);
  });
  
  test('double', () async {
    SimpleDatabase doubleDB = SimpleDatabase(name: 'double');

    List<dynamic> doubleList = await doubleDB.getAll();

    expect(doubleList.length, 0);

    await doubleDB.add(10.4);

    doubleList = await doubleDB.getAll();

    expect(doubleList[0], 10.4);

    await doubleDB.add(11.2);
    await doubleDB.add(0.0);

    doubleList = await doubleDB.getAll();

    expect(doubleList.length, 3);
    expect(doubleList[1], 11.2);
    expect(doubleList[2], 0.0);
  });

  test('class', () async {
    SimpleDatabase classDB = SimpleDatabase(name: 'class', fromJson: (fromJson) => SimpleClass.fromJson(fromJson));

    SimpleClass john = SimpleClass(18, 'John', 5.2, true);

    List<dynamic> classList = await classDB.getAll();

    expect(classList.length, 0);

    await classDB.add(john);
    
    classList = await classDB.getAll();

    expect(classList.length, 1);
    expect(classList[0].name, 'John');
    expect(classList[0].age, 18);
    expect(classList[0].height, 5.2);
    expect(classList[0].gender, true);

    
    await classDB.add(SimpleClass(19, 'Bob', 6.0, true));

    classList = await classDB.getAll();

    int count = await classDB.count();

    expect(count, 2);

    expect(classList.length, 2);
    expect(classList[1].name, 'Bob');
    expect(classList[1].age, 19);
    expect(classList[1].height, 6.0);
    expect(classList[1].gender, true);

    for (SimpleClass person in await classDB.getAll()) {
      expect(person.gender, true);
    }
    
  });

  test('list', () async {
    SimpleDatabase listStringDB = SimpleDatabase(name: 'listString');

    await listStringDB.add(['hello', 'world', '!']);
    await listStringDB.add(['second', 'list']);
    await listStringDB.add(121);

    List<dynamic> strings = await listStringDB.getAll();

    expect(strings[0][0], 'hello');
    expect(strings[1][1], 'list');
    expect(strings[2], 121);
  });
}
