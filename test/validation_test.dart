//@TestOn("vm")
//import 'dart:io';
//import 'dart:async';
//
//import "package:test/test.dart";
//import 'package:json_schema/json_schema.dart';
//
//// Entities
//import 'package:engine/share/modules/entity/entities.dart';
//
//main() {
//  test('Schema must be validated', () async {
//    Map schema;
//    Schema schemeValidator;
//    Company companyExample;
//
//    companyExample = new Company();
//    companyExample.name = 'Dream company';
//    companyExample['url'] = '/url';
//
//    schema = {
//      'type': 'object',
//      'properties': {
//        'name': {'type': 'string'},
//        'url': {'type': 'string'},
//        'router': {'value': 'name'}
//      }
//    };
//
//    schemeValidator = await Schema.createSchema(schema);
//
//    bool validationValue = schemeValidator.validate(companyExample);
//    expect(validationValue, isTrue);
//  });
//
//  test('Company schema must be valid', () async {
//    Map schema;
//    Schema schemeValidator;
//    Company companyExample;
//
//    schema = {
//      'title': 'Company',
//      'type': 'object',
//      'properties': {
//        'name': {
//          'type': 'string',
//          'minLength': 2,
//          'datagram': {'color': 'red'}
//        },
//        'uri': {'type': 'string'},
//      },
//      'required': ['name'],
//      'componentsProperties': {
//        'router': {
//          'path': 'company',
//          'resource': 'companies',
//          'title': 'Company',
//          'humanReadableName': 'Компания'
//        }
//      }
//    };
//
//    companyExample = new Company();
//    companyExample.name = 'Dream Company';
//    companyExample.uri = 'http://dream.com';
//
//    schemeValidator = await Schema.createSchema(schema);
//
//    bool validationValue = await schemeValidator.validate(companyExample);
//    expect(validationValue, isTrue);
//  });
//}
