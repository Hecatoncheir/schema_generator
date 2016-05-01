part of schema;

class SchemasActions {
  // Получение произвольных значений из datagram для конкретного поля
  Map getDatagramForProperty({Map schema, String property}) {
    return schema['properties'][property]['datagram'];
  }

  // Получение схемы компонента из схемы сущности
  Map getSchemaOfComponent({Map schema, String component}) {
    String componentsLink = 'componentsProperties';
    if (schema[componentsLink] != null) {
      return schema[componentsLink][component];
    }
  }

  // Имя поля класса
  String getNameForProperty({Map schema, String propertyName}) {
    Map datagram =
        getDatagramForProperty(schema: schema, property: propertyName);
    return datagram['humanReadableName'];
  }

  // Доступно ли поле класса для отображения
  bool checkPropertyVisible({Map schema, String propertyName}) {
    Map datagram =
        getDatagramForProperty(schema: schema, property: propertyName);
    return datagram['isVisible'];
  }

  // Тип редактора поля класса
  String checkEditorType({Map schema, String propertyName}) {
    Map datagram =
        getDatagramForProperty(schema: schema, property: propertyName);
    return datagram['editorType'];
  }

  // Максимальное количество символов из схемы
  int getMaxLength({Map schema, String propertyName}) {
    return schema['properties'][propertyName]['maxLength'];
  }

  // Минимальное количество символов из схемы
  int getMinLength({Map schema, String propertyName}) {
    return schema['properties'][propertyName]['minLength'];
  }

  // Получение всех полей класса сущности
  List getPropertiesOfEntitySchema({Map schema}) {
    return schema['properties'].keys;
  }
}
