// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_exercise_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCustomExerciseTemplateCollection on Isar {
  IsarCollection<CustomExerciseTemplate> get customExerciseTemplates =>
      this.collection();
}

const CustomExerciseTemplateSchema = CollectionSchema(
  name: r'CustomExerciseTemplate',
  id: -4081273687071629480,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'exerciseKey': PropertySchema(
      id: 1,
      name: r'exerciseKey',
      type: IsarType.string,
    ),
    r'muscleGroup': PropertySchema(
      id: 2,
      name: r'muscleGroup',
      type: IsarType.byte,
      enumMap: _CustomExerciseTemplatemuscleGroupEnumValueMap,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _customExerciseTemplateEstimateSize,
  serialize: _customExerciseTemplateSerialize,
  deserialize: _customExerciseTemplateDeserialize,
  deserializeProp: _customExerciseTemplateDeserializeProp,
  idName: r'id',
  indexes: {
    r'exerciseKey': IndexSchema(
      id: 5360475711065971657,
      name: r'exerciseKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'exerciseKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _customExerciseTemplateGetId,
  getLinks: _customExerciseTemplateGetLinks,
  attach: _customExerciseTemplateAttach,
  version: '3.1.0+1',
);

int _customExerciseTemplateEstimateSize(
  CustomExerciseTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exerciseKey.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _customExerciseTemplateSerialize(
  CustomExerciseTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.exerciseKey);
  writer.writeByte(offsets[2], object.muscleGroup.index);
  writer.writeString(offsets[3], object.name);
}

CustomExerciseTemplate _customExerciseTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomExerciseTemplate();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.exerciseKey = reader.readString(offsets[1]);
  object.id = id;
  object.muscleGroup = _CustomExerciseTemplatemuscleGroupValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      MuscleGroup.chest;
  object.name = reader.readString(offsets[3]);
  return object;
}

P _customExerciseTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (_CustomExerciseTemplatemuscleGroupValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MuscleGroup.chest) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CustomExerciseTemplatemuscleGroupEnumValueMap = {
  'chest': 0,
  'back': 1,
  'legs': 2,
  'shoulders': 3,
  'arms': 4,
  'core': 5,
  'biceps': 6,
  'triceps': 7,
};
const _CustomExerciseTemplatemuscleGroupValueEnumMap = {
  0: MuscleGroup.chest,
  1: MuscleGroup.back,
  2: MuscleGroup.legs,
  3: MuscleGroup.shoulders,
  4: MuscleGroup.arms,
  5: MuscleGroup.core,
  6: MuscleGroup.biceps,
  7: MuscleGroup.triceps,
};

Id _customExerciseTemplateGetId(CustomExerciseTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _customExerciseTemplateGetLinks(
    CustomExerciseTemplate object) {
  return [];
}

void _customExerciseTemplateAttach(
    IsarCollection<dynamic> col, Id id, CustomExerciseTemplate object) {
  object.id = id;
}

extension CustomExerciseTemplateByIndex
    on IsarCollection<CustomExerciseTemplate> {
  Future<CustomExerciseTemplate?> getByExerciseKey(String exerciseKey) {
    return getByIndex(r'exerciseKey', [exerciseKey]);
  }

  CustomExerciseTemplate? getByExerciseKeySync(String exerciseKey) {
    return getByIndexSync(r'exerciseKey', [exerciseKey]);
  }

  Future<bool> deleteByExerciseKey(String exerciseKey) {
    return deleteByIndex(r'exerciseKey', [exerciseKey]);
  }

  bool deleteByExerciseKeySync(String exerciseKey) {
    return deleteByIndexSync(r'exerciseKey', [exerciseKey]);
  }

  Future<List<CustomExerciseTemplate?>> getAllByExerciseKey(
      List<String> exerciseKeyValues) {
    final values = exerciseKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'exerciseKey', values);
  }

  List<CustomExerciseTemplate?> getAllByExerciseKeySync(
      List<String> exerciseKeyValues) {
    final values = exerciseKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'exerciseKey', values);
  }

  Future<int> deleteAllByExerciseKey(List<String> exerciseKeyValues) {
    final values = exerciseKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'exerciseKey', values);
  }

  int deleteAllByExerciseKeySync(List<String> exerciseKeyValues) {
    final values = exerciseKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'exerciseKey', values);
  }

  Future<Id> putByExerciseKey(CustomExerciseTemplate object) {
    return putByIndex(r'exerciseKey', object);
  }

  Id putByExerciseKeySync(CustomExerciseTemplate object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'exerciseKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByExerciseKey(List<CustomExerciseTemplate> objects) {
    return putAllByIndex(r'exerciseKey', objects);
  }

  List<Id> putAllByExerciseKeySync(List<CustomExerciseTemplate> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'exerciseKey', objects, saveLinks: saveLinks);
  }
}

extension CustomExerciseTemplateQueryWhereSort
    on QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QWhere> {
  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension CustomExerciseTemplateQueryWhere on QueryBuilder<
    CustomExerciseTemplate, CustomExerciseTemplate, QWhereClause> {
  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> exerciseKeyEqualTo(String exerciseKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'exerciseKey',
        value: [exerciseKey],
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> exerciseKeyNotEqualTo(String exerciseKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseKey',
              lower: [],
              upper: [exerciseKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseKey',
              lower: [exerciseKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseKey',
              lower: [exerciseKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseKey',
              lower: [],
              upper: [exerciseKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterWhereClause> createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CustomExerciseTemplateQueryFilter on QueryBuilder<
    CustomExerciseTemplate, CustomExerciseTemplate, QFilterCondition> {
  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> exerciseKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> exerciseKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> exerciseKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> exerciseKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> exerciseKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> exerciseKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
          QAfterFilterCondition>
      exerciseKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
          QAfterFilterCondition>
      exerciseKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> exerciseKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseKey',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> exerciseKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseKey',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> muscleGroupEqualTo(MuscleGroup value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> muscleGroupGreaterThan(
    MuscleGroup value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'muscleGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> muscleGroupLessThan(
    MuscleGroup value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'muscleGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> muscleGroupBetween(
    MuscleGroup lower,
    MuscleGroup upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'muscleGroup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension CustomExerciseTemplateQueryObject on QueryBuilder<
    CustomExerciseTemplate, CustomExerciseTemplate, QFilterCondition> {}

extension CustomExerciseTemplateQueryLinks on QueryBuilder<
    CustomExerciseTemplate, CustomExerciseTemplate, QFilterCondition> {}

extension CustomExerciseTemplateQuerySortBy
    on QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QSortBy> {
  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      sortByExerciseKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseKey', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      sortByExerciseKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseKey', Sort.desc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      sortByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      sortByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CustomExerciseTemplateQuerySortThenBy on QueryBuilder<
    CustomExerciseTemplate, CustomExerciseTemplate, QSortThenBy> {
  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByExerciseKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseKey', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByExerciseKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseKey', Sort.desc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CustomExerciseTemplateQueryWhereDistinct
    on QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QDistinct> {
  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QDistinct>
      distinctByExerciseKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QDistinct>
      distinctByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleGroup');
    });
  }

  QueryBuilder<CustomExerciseTemplate, CustomExerciseTemplate, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension CustomExerciseTemplateQueryProperty on QueryBuilder<
    CustomExerciseTemplate, CustomExerciseTemplate, QQueryProperty> {
  QueryBuilder<CustomExerciseTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CustomExerciseTemplate, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CustomExerciseTemplate, String, QQueryOperations>
      exerciseKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseKey');
    });
  }

  QueryBuilder<CustomExerciseTemplate, MuscleGroup, QQueryOperations>
      muscleGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroup');
    });
  }

  QueryBuilder<CustomExerciseTemplate, String, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
