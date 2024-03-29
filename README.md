# Simple Database
![CI](https://github.com/gquarles/simple_database/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/gquarles/simple_database/branch/master/graph/badge.svg)](https://codecov.io/gh/gquarles/simple_database)

A simple lightweight wrapper for the [SharedPreferences](https://pub.dev/packages/shared_preferences) Flutter package. Simple Database provides an abstraction layer for storing objects instead of key, value pairs. This makes it very easy to get a quick local storage solution up and running.

### GitHub
Please feel free to [contribute](https://github.com/gquarles/simple_database)

## Usage
Please add `simple_database` as a dependency in your pubspec.yaml file


## No Setup Primative Storage
You can easily setup a database of primitive types just by assigning it a name, Simple Database will init the DB if it has not been created yet on the phone for you.

```dart
void main() async {
    SimpleDatabase names = SimpleDatabase(name: 'names');

    await names.add('Bob');
    await names.add('Doug');

    for (var name in await names.getAllType<String>()) {
      print(name);
    }
}
```

## Mixed Types
You can use a single database that stores multiple primitive types and then specify what type you want from the database.
```dart
void main() async {
    SimpleDatabase names = SimpleDatabase(name: 'names');

    await names.add('Bob');
    await names.add(150)
    await names.add('Doug');
  
    //Print out all strings in the db
    for (var name in await names.getAllType<String>()) {
      print(name);
    }
  
    //Print out at an index, with a type
    var number = await names.getAtType<int>(1);
    print(number);
}
```

## Non-Primitive object storage
You can store your own objects you have created easily just by implementing **2** functions in the class. **toJson** and **fromJson**. You will need to pass the **fromJson** function to the constructor of SimpleDatabase if you want it to rebuild the json into your object. You do not *need* this, it will just return a hash map with the values from your object if the function is not provided.

```dart

class SimpleClass {
  final int age;
  final String name;
  final double height;
  final bool gender;

  SimpleClass(this.age, this.name, this.height, this.gender);

  //Implement fromJson - Required
  SimpleClass.fromJson(Map<String, dynamic> json) : age = json['age'], name = json['name'], height = json['height'], gender = json['gender'];

  //Implement toJson - Required
  Map<String, dynamic> toJson() => {
    'age': age,
    'name' : name,
    'height' : height,
    'gender' : gender,
  };
}

void main() async {
    SimpleDatabase classDB = SimpleDatabase(name: 'class', fromJson: (fromJson) => SimpleClass.fromJson(fromJson));

    SimpleClass john = SimpleClass(18, 'John', 5.2, true);  

    await classDB.add(john);

    SimpleClass person = await classDB.getAtType<SimpleClass>(0);
    print(person.name);
}
```

## TODO:
* Built in encryption of stored json strings
* Better documentation