import '../lib/simple_database.dart';

void main() async {
    SimpleDatabase names = SimpleDatabase(name: 'names');

    await names.add('Bob');
    await names.add('Doug');

    for (var name in await names.getAll()) {
      print(name);
    }
}