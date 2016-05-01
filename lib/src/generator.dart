part of schema;

/// Нужно добавить параметры resource

/// Аннотация обозначающая схему
class Schema {
  final String title;
  final String type;
  final String resource;
  final bool additionalProperties;
  const Schema(
      {this.title, this.resource, this.type, this.additionalProperties: true});
}

/// Аннотация обозначающая свойства полей для схемы
class SchemaProperty {
  final String name;
  final String type;
  final bool required;
  final num minLength;
  final num maxLength;
  const SchemaProperty(
      {this.name, this.type, this.required, this.minLength, this.maxLength});
}

/// Аннотация обозначающая дополнительные свойства полей для схемы
class SchemaDatagramProperty {
  final Map datagram;
  const SchemaDatagramProperty(this.datagram);
}

/// Аннотация обозначающая дополнительные значения для схемы
class AdditionalSchemaProperties {
  final String type;
  final Map properties;
  const AdditionalSchemaProperties({this.type: 'object', this.properties});
}

/// Аннотация обозначающая дополнительные значения для компонентов
class ComponentsSchemaProperties {
  final Map datagram;
  const ComponentsSchemaProperties(this.datagram);
}

/// Подготовка схем
Map prepareSchema(String libraryName) {
  MirrorSystem mirrorSystem = currentMirrorSystem();
  LibraryMirror schemeLibraryInspector =
      mirrorSystem.findLibrary(new Symbol(libraryName));

  Map annotatedClasses =
      getAnnotatedSchemasEntities(schemeLibraryInspector.declarations);

  return annotatedClasses;
}

/// Получение аннотаций из классов сущностей
Map getAnnotatedSchemasEntities(Map libraryClassesDeclarations) {
  Map annotatedClasses = new Map();

  libraryClassesDeclarations.forEach((symbols, classes) {
    classes.metadata.any((InstanceMirror annotationOfElement) {
      String className = MirrorSystem.getName(symbols);
      Map classSchemeFields = new Map();

      // schema properties
      if (annotationOfElement.reflectee is Schema) {
        Map annotatedProperties =
            getAnnotatedSchemaPropertiesOfClassFields(classes);

        classSchemeFields['title'] = annotationOfElement.reflectee.title;
        classSchemeFields['title'] = annotationOfElement.reflectee.resource;
        classSchemeFields['type'] = annotationOfElement.reflectee.type;

        classSchemeFields['properties'] = annotatedProperties['classFields'];
        classSchemeFields['required'] =
            annotatedProperties['classRequiredFields'];

        annotatedClasses[className] = classSchemeFields;
      }

      // additional schema properties
      if (annotationOfElement.reflectee is AdditionalSchemaProperties) {
        Map additionalProperties = new Map();

        additionalProperties['type'] = annotationOfElement.reflectee.type;
        additionalProperties['properties'] =
            annotationOfElement.reflectee.properties;

        annotatedClasses[className]['additionalProperties'] =
            additionalProperties;
      }

      // components schema properties
      if (annotationOfElement.reflectee is ComponentsSchemaProperties) {
        annotatedClasses[className]['componentsProperties'] =
            annotationOfElement.reflectee.datagram;
      }
    });
  });

  return annotatedClasses;
}

/// Получение аннотаций из полей классов сущностей
Map getAnnotatedSchemaPropertiesOfClassFields(schemaAnnotatedClass) {
  Map classFields = new Map();
  List classRequiredFields = new List<String>();
  Map classFieldsDetails = {
    'classFields': classFields,
    'classRequiredFields': classRequiredFields
  };

  schemaAnnotatedClass.declarations
      .forEach((annotatedFieldSymbolName, MethodMirror fieldMirror) {
    Map fieldProperties = new Map();
    String fieldName;

    fieldMirror.metadata.any((InstanceMirror annotation) {
      // schema properties
      if (annotation.reflectee is SchemaProperty) {
        // check field name
        if (annotation.reflectee != null && annotation.reflectee.name != null) {
          fieldName = annotation.reflectee.name;
        } else {
          fieldName = MirrorSystem.getName(annotatedFieldSymbolName);
        }

        // check maxLength
        if (annotation.reflectee.maxLength != null) {
          fieldProperties['maxLength'] = annotation.reflectee.maxLength;
        }

        // check minLength
        if (annotation.reflectee.minLength != null) {
          fieldProperties['minLength'] = annotation.reflectee.minLength;
        }

        // check field required option
        if (annotation.reflectee.required == true) {
          classRequiredFields.add(fieldName);
        }

        fieldProperties['type'] = annotation.reflectee.type;
      }

      // schema properties datagram
      if (annotation.reflectee is SchemaDatagramProperty) {
        Map datagram = new Map();
        Map reflectedDatagram = annotation.reflectee.datagram;

        if (reflectedDatagram['isVisible'] == null) {
          datagram['isVisible'] = true;
        } else {
          datagram['isVisible'] = reflectedDatagram['isVisible'];
        }

        if (reflectedDatagram['humanReadableName'] == null) {
          datagram['humanReadableName'] = '-- Имя не задано --';
        } else {
          datagram['humanReadableName'] =
              reflectedDatagram['humanReadableName'];
        }

        if (reflectedDatagram['editorType'] == null) {
          datagram['editorType'] = 'TextEditor';
        } else {
          datagram['editorType'] = reflectedDatagram['editorType'];
        }

        fieldProperties['datagram'] = datagram;
      }

      classFields[fieldName] = fieldProperties;
    });
  });

  return classFieldsDetails;
}
