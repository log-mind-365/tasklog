import 'package:drift/drift.dart';

import '../../domain/entities/folder_entity.dart';
import '../datasources/local/database.dart';

extension FolderMapper on Folder {
  FolderEntity toEntity() {
    return FolderEntity(id: id, name: name, color: color, order: order);
  }
}

extension FolderEntityMapper on FolderEntity {
  FoldersCompanion toCompanion() {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      order: Value(order),
    );
  }

  FoldersCompanion toInsertCompanion() {
    return FoldersCompanion.insert(
      name: name,
      color: color,
      order: Value(order),
    );
  }

  Folder toDriftModel() {
    return Folder(id: id, name: name, color: color, order: order);
  }
}
