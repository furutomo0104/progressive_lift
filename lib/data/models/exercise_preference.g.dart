// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_preference.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExercisePreferenceCollection on Isar {
  IsarCollection<ExercisePreference> get exercisePreferences =>
      this.collection();
}

const ExercisePreferenceSchema = CollectionSchema(
  name: r'ExercisePreference',
  id: -6514635585618702292,
  properties: {
    r'exerciseKey': PropertySchema(
      id: 0,
      name: r'exerciseKey',
      type: IsarType.string,
    ),
    r'hasMuscleGroupOverride': PropertySchema(
      id: 1,
      name: r'hasMuscleGroupOverride',
      type: IsarType.bool,
    ),
    r'isHidden': PropertySchema(
      id: 2,
      name: r'isHidden',
      type: IsarType.bool,
    ),
    r'muscleGroupOverride': PropertySchema(
      id: 3,
      name: r'muscleGroupOverride',
      type: IsarType.byte,
      enumMap: _ExercisePreferencemuscleGroupOverrideEnumValueMap,
    ),
    r'nameOverride': PropertySchema(
      id: 4,
      name: r'nameOverride',
      type: IsarType.string,
    )
  },
  estimateSize: _exercisePreferenceEstimateSize,
  serialize: _exercisePreferenceSerialize,
  deserialize: _exercisePreferenceDeserialize,
  deserializeProp: _exercisePreferenceDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _exercisePreferenceGetId,
  getLinks: _exercisePreferenceGetLinks,
  attach: _exercisePreferenceAttach,
  version: '3.1.0+1',
);

int _exercisePreferenceEstimateSize(
  ExercisePreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exerciseKey.length * 3;
  {
    final value = object.nameOverride;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _exercisePreferenceSerialize(
  ExercisePreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.exerciseKey);
  writer.writeBool(offsets[1], object.hasMuscleGroupOverride);
  writer.writeBool(offsets[2], object.isHidden);
  writer.writeByte(offsets[3], object.muscleGroupOverride.index);
  writer.writeString(offsets[4], object.nameOverride);
}

ExercisePreference _exercisePreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExercisePreference();
  object.exerciseKey = reader.readString(offsets[0]);
  object.hasMuscleGroupOverride = reader.readBool(offsets[1]);
  object.id = id;
  object.isHidden = reader.readBool(offsets[2]);
  object.muscleGroupOverride =
      _ExercisePreferencemuscleGroupOverrideValueEnumMap[
              reader.readByteOrNull(offsets[3])] ??
          MuscleGroup.chest;
  object.nameOverride = reader.readStringOrNull(offsets[4]);
  return object;
}

P _exercisePreferenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (_ExercisePreferencemuscleGroupOverrideValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MuscleGroup.chest) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ExercisePreferencemuscleGroupOverrideEnumValueMap = {
  'chest': 0,
  'back': 1,
  'legs': 2,
  'shoulders': 3,
  'arms': 4,
  'core': 5,
  'biceps': 6,
  'triceps': 7,
};
const _ExercisePreferencemuscleGroupOverrideValueEnumMap = {
  0: MuscleGroup.chest,
  1: MuscleGroup.back,
  2: MuscleGroup.legs,
  3: MuscleGroup.shoulders,
  4: MuscleGroup.arms,
  5: MuscleGroup.core,
  6: MuscleGroup.biceps,
  7: MuscleGroup.triceps,
};

Id _exercisePreferenceGetId(ExercisePreference object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _exercisePreferenceGetLinks(
    ExercisePreference object) {
  return [];
}

void _exercisePreferenceAttach(
    IsarCollection<dynamic> col, Id id, ExercisePreference object) {
  object.id = id;
}

extension ExercisePreferenceByIndex on IsarCollection<ExercisePreference> {
  Future<ExercisePreference?> getByExerciseKey(String exerciseKey) {
    return getByIndex(r'exerciseKey', [exerciseKey]);
  }

  ExercisePreference? getByExerciseKeySync(String exerciseKey) {
    return getByIndexSync(r'exerciseKey', [exerciseKey]);
  }

  Future<bool> deleteByExerciseKey(String exerciseKey) {
    return deleteByIndex(r'exerciseKey', [exerciseKey]);
  }

  bool deleteByExerciseKeySync(String exerciseKey) {
    return deleteByIndexSync(r'exerciseKey', [exerciseKey]);
  }

  Future<List<ExercisePreference?>> getAllByExerciseKey(
      List<String> exerciseKeyValues) {
    final values = exerciseKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'exerciseKey', values);
  }

  List<ExercisePreference?> getAllByExerciseKeySync(
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

  Future<Id> putByExerciseKey(ExercisePreference object) {
    return putByIndex(r'exerciseKey', object);
  }

  Id putByExerciseKeySync(ExercisePreference object, {bool saveLinks = true}) {
    return putByIndexSync(r'exerciseKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByExerciseKey(List<ExercisePreference> objects) {
    return putAllByIndex(r'exerciseKey', objects);
  }

  List<Id> putAllByExerciseKeySync(List<ExercisePreference> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'exerciseKey', objects, saveLinks: saveLinks);
  }
}

extension ExercisePreferenceQueryWhereSort
    on QueryBuilder<ExercisePreference, ExercisePreference, QWhere> {
  QueryBuilder<ExercisePreference, ExercisePreference, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExercisePreferenceQueryWhere
    on QueryBuilder<ExercisePreference, ExercisePreference, QWhereClause> {
  QueryBuilder<ExercisePreference, ExercisePreference, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterWhereClause>
      exerciseKeyEqualTo(String exerciseKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'exerciseKey',
        value: [exerciseKey],
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterWhereClause>
      exerciseKeyNotEqualTo(String exerciseKey) {
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
}

extension ExercisePreferenceQueryFilter
    on QueryBuilder<ExercisePreference, ExercisePreference, QFilterCondition> {
  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyEqualTo(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyGreaterThan(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyLessThan(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyBetween(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyStartsWith(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyEndsWith(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      exerciseKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      hasMuscleGroupOverrideEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasMuscleGroupOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      isHiddenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isHidden',
        value: value,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      muscleGroupOverrideEqualTo(MuscleGroup value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroupOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      muscleGroupOverrideGreaterThan(
    MuscleGroup value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'muscleGroupOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      muscleGroupOverrideLessThan(
    MuscleGroup value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'muscleGroupOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      muscleGroupOverrideBetween(
    MuscleGroup lower,
    MuscleGroup upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'muscleGroupOverride',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nameOverride',
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nameOverride',
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameOverride',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameOverride',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameOverride',
        value: '',
      ));
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterFilterCondition>
      nameOverrideIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameOverride',
        value: '',
      ));
    });
  }
}

extension ExercisePreferenceQueryObject
    on QueryBuilder<ExercisePreference, ExercisePreference, QFilterCondition> {}

extension ExercisePreferenceQueryLinks
    on QueryBuilder<ExercisePreference, ExercisePreference, QFilterCondition> {}

extension ExercisePreferenceQuerySortBy
    on QueryBuilder<ExercisePreference, ExercisePreference, QSortBy> {
  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByExerciseKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseKey', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByExerciseKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseKey', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByHasMuscleGroupOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMuscleGroupOverride', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByHasMuscleGroupOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMuscleGroupOverride', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByIsHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHidden', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByIsHiddenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHidden', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByMuscleGroupOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroupOverride', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByMuscleGroupOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroupOverride', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByNameOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameOverride', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      sortByNameOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameOverride', Sort.desc);
    });
  }
}

extension ExercisePreferenceQuerySortThenBy
    on QueryBuilder<ExercisePreference, ExercisePreference, QSortThenBy> {
  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByExerciseKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseKey', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByExerciseKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseKey', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByHasMuscleGroupOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMuscleGroupOverride', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByHasMuscleGroupOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMuscleGroupOverride', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByIsHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHidden', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByIsHiddenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHidden', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByMuscleGroupOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroupOverride', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByMuscleGroupOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroupOverride', Sort.desc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByNameOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameOverride', Sort.asc);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QAfterSortBy>
      thenByNameOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameOverride', Sort.desc);
    });
  }
}

extension ExercisePreferenceQueryWhereDistinct
    on QueryBuilder<ExercisePreference, ExercisePreference, QDistinct> {
  QueryBuilder<ExercisePreference, ExercisePreference, QDistinct>
      distinctByExerciseKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QDistinct>
      distinctByHasMuscleGroupOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasMuscleGroupOverride');
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QDistinct>
      distinctByIsHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isHidden');
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QDistinct>
      distinctByMuscleGroupOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleGroupOverride');
    });
  }

  QueryBuilder<ExercisePreference, ExercisePreference, QDistinct>
      distinctByNameOverride({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameOverride', caseSensitive: caseSensitive);
    });
  }
}

extension ExercisePreferenceQueryProperty
    on QueryBuilder<ExercisePreference, ExercisePreference, QQueryProperty> {
  QueryBuilder<ExercisePreference, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExercisePreference, String, QQueryOperations>
      exerciseKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseKey');
    });
  }

  QueryBuilder<ExercisePreference, bool, QQueryOperations>
      hasMuscleGroupOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasMuscleGroupOverride');
    });
  }

  QueryBuilder<ExercisePreference, bool, QQueryOperations> isHiddenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isHidden');
    });
  }

  QueryBuilder<ExercisePreference, MuscleGroup, QQueryOperations>
      muscleGroupOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroupOverride');
    });
  }

  QueryBuilder<ExercisePreference, String?, QQueryOperations>
      nameOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameOverride');
    });
  }
}
