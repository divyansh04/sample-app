import 'package:hive/hive.dart';

part 'inventory_model.g.dart';

@HiveType()
class Inventory {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String age;

  Inventory({this.name, this.description, this.age});
}
