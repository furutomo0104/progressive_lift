// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_set.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExerciseSetCollection on Isar {
  IsarCollection<ExerciseSet> get exerciseSets => this.collection();
}

const ExerciseSetSchema = CollectionSchema(
  name: r'ExerciseSet',
  id: 5316752631366182897,
  properties: {
    r'exerciseRecordId': PropertySchema(
      id: 0,
      name: r'exerciseRecordId',
      type: IsarType.long,
    ),
    r'memo': PropertySchema(
      id: 1,
      name: r'memo',
      type: IsarType.string,
    ),
    r'recordedAt': PropertySchema(
      id: 2,
      name: r'recordedAt',
      type: IsarType.dateTime,
    ),
    r'reps': PropertySchema(
      id: 3,
      name: r'reps',
      type: IsarType.long,
    ),
    r'setOrder': PropertySchema(
      id: 4,
      name: r'setOrder',
      type: IsarType.long,
    ),
    r'weightKg': PropertySchema(
      id: 5,
      name: r'weightKg',
      type: IsarType.double,
    )
  },
  estimateSize: _exerciseSetEstimateSize,
  serialize: _exerciseSetSerialize,
  deserialize: _exerciseSetDeserialize,
  deserializeProp: _exerciseSetDeserializeProp,
  idName: r'id',
  indexes: {
    r'exerciseRecordId': IndexSchema(
      id: 9161138006589665143,
      name: r'exerciseRecordId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'exerciseRecordId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _exerciseSetGetId,
  getLinks: _exerciseSetGetLinks,
  attach: _exerciseSetAttach,
  version: '3.1.0+1',
);

int _exerciseSetEstimateSize(
  ExerciseSet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.memo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _exerciseSetSerialize(
  ExerciseSet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.exerciseRecordId);
  writer.writeString(offsets[1], object.memo);
  writer.writeDateTime(offsets[2], object.recordedAt);
  writer.writeLong(offsets[3], object.reps);
  writer.writeLong(offsets[4], object.setOrder);
  writer.writeDouble(offsets[5], object.weightKg);
}

ExerciseSet _exerciseSetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExerciseSet();
  object.exerciseRecordId = reader.readLong(offsets[0]);
  object.id = id;
  object.memo = reader.readStringOrNull(offsets[1]);
  object.recordedAt = reader.readDateTimeOrNull(offsets[2]);
  object.reps = reader.readLong(offsets[3]);
  object.setOrder = reader.readLong(offsets[4]);
  object.weightKg = reader.readDouble(offsets[5]);
  return object;
}

P _exerciseSetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _exerciseSetGetId(ExerciseSet object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _exerciseSetGetLinks(ExerciseSet object) {
  return [];
}

void _exerciseSetAttach(
    IsarCollection<dynamic> col, Id id, ExerciseSet object) {
  object.id = id;
}

extension ExerciseSetQueryWhereSort
    on QueryBuilder<ExerciseSet, ExerciseSet, QWhere> {
  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhere> anyExerciseRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'exerciseRecordId'),
      );
    });
  }
}

extension ExerciseSetQueryWhere
    on QueryBuilder<ExerciseSet, ExerciseSet, QWhereClause> {
  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause> idBetween(
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

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause>
      exerciseRecordIdEqualTo(int exerciseRecordId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'exerciseRecordId',
        value: [exerciseRecordId],
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause>
      exerciseRecordIdNotEqualTo(int exerciseRecordId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseRecordId',
              lower: [],
              upper: [exerciseRecordId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseRecordId',
              lower: [exerciseRecordId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseRecordId',
              lower: [exerciseRecordId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseRecordId',
              lower: [],
              upper: [exerciseRecordId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause>
      exerciseRecordIdGreaterThan(
    int exerciseRecordId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'exerciseRecordId',
        lower: [exerciseRecordId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause>
      exerciseRecordIdLessThan(
    int exerciseRecordId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'exerciseRecordId',
        lower: [],
        upper: [exerciseRecordId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterWhereClause>
      exerciseRecordIdBetween(
    int lowerExerciseRecordId,
    int upperExerciseRecordId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'exerciseRecordId',
        lower: [lowerExerciseRecordId],
        includeLower: includeLower,
        upper: [upperExerciseRecordId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExerciseSetQueryFilter
    on QueryBuilder<ExerciseSet, ExerciseSet, QFilterCondition> {
  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      exerciseRecordIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseRecordId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      exerciseRecordIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseRecordId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      exerciseRecordIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseRecordId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      exerciseRecordIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseRecordId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'memo',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      memoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'memo',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'memo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'memo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> memoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      memoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      recordedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recordedAt',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      recordedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recordedAt',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      recordedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      recordedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      recordedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      recordedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> setOrderEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      setOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      setOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> setOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> weightKgEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      weightKgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      weightKgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> weightKgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weightKg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ExerciseSetQueryObject
    on QueryBuilder<ExerciseSet, ExerciseSet, QFilterCondition> {}

extension ExerciseSetQueryLinks
    on QueryBuilder<ExerciseSet, ExerciseSet, QFilterCondition> {}

extension ExerciseSetQuerySortBy
    on QueryBuilder<ExerciseSet, ExerciseSet, QSortBy> {
  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy>
      sortByExerciseRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseRecordId', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy>
      sortByExerciseRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseRecordId', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortByRecordedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortByReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reps', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortByRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reps', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortBySetOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setOrder', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortBySetOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setOrder', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> sortByWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.desc);
    });
  }
}

extension ExerciseSetQuerySortThenBy
    on QueryBuilder<ExerciseSet, ExerciseSet, QSortThenBy> {
  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy>
      thenByExerciseRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseRecordId', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy>
      thenByExerciseRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseRecordId', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByRecordedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reps', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reps', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenBySetOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setOrder', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenBySetOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setOrder', Sort.desc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.asc);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterSortBy> thenByWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.desc);
    });
  }
}

extension ExerciseSetQueryWhereDistinct
    on QueryBuilder<ExerciseSet, ExerciseSet, QDistinct> {
  QueryBuilder<ExerciseSet, ExerciseSet, QDistinct>
      distinctByExerciseRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseRecordId');
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QDistinct> distinctByMemo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QDistinct> distinctByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordedAt');
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QDistinct> distinctByReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reps');
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QDistinct> distinctBySetOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setOrder');
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QDistinct> distinctByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weightKg');
    });
  }
}

extension ExerciseSetQueryProperty
    on QueryBuilder<ExerciseSet, ExerciseSet, QQueryProperty> {
  QueryBuilder<ExerciseSet, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExerciseSet, int, QQueryOperations> exerciseRecordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseRecordId');
    });
  }

  QueryBuilder<ExerciseSet, String?, QQueryOperations> memoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memo');
    });
  }

  QueryBuilder<ExerciseSet, DateTime?, QQueryOperations> recordedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordedAt');
    });
  }

  QueryBuilder<ExerciseSet, int, QQueryOperations> repsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reps');
    });
  }

  QueryBuilder<ExerciseSet, int, QQueryOperations> setOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setOrder');
    });
  }

  QueryBuilder<ExerciseSet, double, QQueryOperations> weightKgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weightKg');
    });
  }
}
