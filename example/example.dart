import '../lib/simple_database.dart';

void main() async {
    SimpleDatabase names = SimpleDatabase(name: 'names');

    await names.add('Bob');
    await names.add('Doug');

    //Get all of the strings in the database
    for (var name in await names.getAllType<String>()) {
      print(name);
    }
}