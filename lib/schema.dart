library schema;

import 'dart:mirrors';

part 'src/generator.dart';
part 'src/actions.dart';

class SchemaGenerator extends Object with SchemasActions {
  Map allEntitiesSchemas;

  String _entitiesLibrary;

  SchemaGenerator({String fromLibrary: 'entities'}) {
    this._entitiesLibrary = fromLibrary;
    allEntitiesSchemas = prepareSchema(_entitiesLibrary);
  }

  // Get all schemas
  Map getSchemasOfAllEntities() {
    return allEntitiesSchemas;
  }

  // Get only one schema of entity
  Map getSchemaOfEntity({String entityName}) {
    if (allEntitiesSchemas == null) {
      allEntitiesSchemas = prepareSchema(_entitiesLibrary);
    }
    return allEntitiesSchemas[entityName];
  }

  operator [](String cacheResource) {
    return allEntitiesSchemas[cacheResource];
  }
}
