import 'package:drift/drift.dart';
import '../../domain/entities/category_entity.dart';
import '../datasources/local/database.dart';

extension CategoryMapper on Category {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      color: color,
    );
  }
}

extension CategoryEntityMapper on CategoryEntity {
  CategoriesCompanion toCompanion() {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
    );
  }

  CategoriesCompanion toInsertCompanion() {
    return CategoriesCompanion.insert(
      name: name,
      color: color,
    );
  }

  Category toDriftModel() {
    return Category(
      id: id,
      name: name,
      color: color,
    );
  }
}
