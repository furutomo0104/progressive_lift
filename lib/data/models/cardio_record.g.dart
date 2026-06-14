// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cardio_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCardioRecordCollection on Isar {
  IsarCollection<CardioRecord> get cardioRecords => this.collection();
}

const CardioRecordSchema = CollectionSchema(
  name: r'CardioRecord',
  id: 6307239099067294788,
  properties: {
    r'durationMinutes': PropertySchema(
      id: 0,
      name: r'durationMinutes',
      type: IsarType.long,
    ),
    r'intervalRestSeconds': PropertySchema(
      id: 1,
      name: r'intervalRestSeconds',
      type: IsarType.long,
    ),
    r'intervalRounds': PropertySchema(
      id: 2,
      name: r'intervalRounds',
      type: IsarType.long,
    ),
    r'intervalWorkSeconds': PropertySchema(
      id: 3,
      name: r'intervalWorkSeconds',
      type: IsarType.long,
    ),
    r'memo': PropertySchema(
      id: 4,
      name: r'memo',
      type: IsarType.string,
    ),
    r'mode': PropertySchema(
      id: 5,
      name: r'mode',
      type: IsarType.byte,
      enumMap: _CardioRecordmodeEnumValueMap,
    ),
    r'sessionId': PropertySchema(
      id: 6,
      name: r'sessionId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.byte,
      enumMap: _CardioRecordtypeEnumValueMap,
    )
  },
  estimateSize: _cardioRecordEstimateSize,
  serialize: _cardioRecordSerialize,
  deserialize: _cardioRecordDeserialize,
  deserializeProp: _cardioRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'sessionId': IndexSchema(
      id: 6949518585047923839,
      name: r'sessionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sessionId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cardioRecordGetId,
  getLinks: _cardioRecordGetLinks,
  attach: _cardioRecordAttach,
  version: '3.1.0+1',
);

int _cardioRecordEstimateSize(
  CardioRecord object,
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

void _cardioRecordSerialize(
  CardioRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMinutes);
  writer.writeLong(offsets[1], object.intervalRestSeconds);
  writer.writeLong(offsets[2], object.intervalRounds);
  writer.writeLong(offsets[3], object.intervalWorkSeconds);
  writer.writeString(offsets[4], object.memo);
  writer.writeByte(offsets[5], object.mode.index);
  writer.writeLong(offsets[6], object.sessionId);
  writer.writeByte(offsets[7], object.type.index);
}

CardioRecord _cardioRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CardioRecord();
  object.durationMinutes = reader.readLong(offsets[0]);
  object.id = id;
  object.intervalRestSeconds = reader.readLongOrNull(offsets[1]);
  object.intervalRounds = reader.readLongOrNull(offsets[2]);
  object.intervalWorkSeconds = reader.readLongOrNull(offsets[3]);
  object.memo = reader.readStringOrNull(offsets[4]);
  object.mode =
      _CardioRecordmodeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          CardioRecordMode.duration;
  object.sessionId = reader.readLong(offsets[6]);
  object.type =
      _CardioRecordtypeValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          CardioType.run;
  return object;
}

P _cardioRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (_CardioRecordmodeValueEnumMap[reader.readByteOrNull(offset)] ??
          CardioRecordMode.duration) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (_CardioRecordtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          CardioType.run) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CardioRecordmodeEnumValueMap = {
  'duration': 0,
  'interval': 1,
};
const _CardioRecordmodeValueEnumMap = {
  0: CardioRecordMode.duration,
  1: CardioRecordMode.interval,
};
const _CardioRecordtypeEnumValueMap = {
  'run': 0,
  'walk': 1,
  'bike': 2,
  'elliptical': 3,
  'other': 4,
};
const _CardioRecordtypeValueEnumMap = {
  0: CardioType.run,
  1: CardioType.walk,
  2: CardioType.bike,
  3: CardioType.elliptical,
  4: CardioType.other,
};

Id _cardioRecordGetId(CardioRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cardioRecordGetLinks(CardioRecord object) {
  return [];
}

void _cardioRecordAttach(
    IsarCollection<dynamic> col, Id id, CardioRecord object) {
  object.id = id;
}

extension CardioRecordQueryWhereSort
    on QueryBuilder<CardioRecord, CardioRecord, QWhere> {
  QueryBuilder<CardioRecord, CardioRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhere> anySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sessionId'),
      );
    });
  }
}

extension CardioRecordQueryWhere
    on QueryBuilder<CardioRecord, CardioRecord, QWhereClause> {
  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause> sessionIdEqualTo(
      int sessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionId',
        value: [sessionId],
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause>
      sessionIdNotEqualTo(int sessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause>
      sessionIdGreaterThan(
    int sessionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionId',
        lower: [sessionId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause> sessionIdLessThan(
    int sessionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionId',
        lower: [],
        upper: [sessionId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterWhereClause> sessionIdBetween(
    int lowerSessionId,
    int upperSessionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionId',
        lower: [lowerSessionId],
        includeLower: includeLower,
        upper: [upperSessionId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CardioRecordQueryFilter
    on QueryBuilder<CardioRecord, CardioRecord, QFilterCondition> {
  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      durationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      durationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      durationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      durationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRestSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intervalRestSeconds',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRestSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intervalRestSeconds',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRestSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRestSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRestSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRestSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalRestSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRoundsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intervalRounds',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRoundsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intervalRounds',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRoundsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalRounds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRoundsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalRounds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRoundsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalRounds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalRoundsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalRounds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalWorkSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intervalWorkSeconds',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalWorkSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intervalWorkSeconds',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalWorkSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalWorkSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalWorkSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalWorkSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalWorkSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalWorkSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      intervalWorkSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalWorkSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> memoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'memo',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      memoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'memo',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> memoEqualTo(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      memoGreaterThan(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> memoLessThan(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> memoBetween(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      memoStartsWith(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> memoEndsWith(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> memoContains(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> memoMatches(
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

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      memoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      memoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> modeEqualTo(
      CardioRecordMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mode',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      modeGreaterThan(
    CardioRecordMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mode',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> modeLessThan(
    CardioRecordMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mode',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> modeBetween(
    CardioRecordMode lower,
    CardioRecordMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      sessionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      sessionIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      sessionIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      sessionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> typeEqualTo(
      CardioType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition>
      typeGreaterThan(
    CardioType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> typeLessThan(
    CardioType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterFilterCondition> typeBetween(
    CardioType lower,
    CardioType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CardioRecordQueryObject
    on QueryBuilder<CardioRecord, CardioRecord, QFilterCondition> {}

extension CardioRecordQueryLinks
    on QueryBuilder<CardioRecord, CardioRecord, QFilterCondition> {}

extension CardioRecordQuerySortBy
    on QueryBuilder<CardioRecord, CardioRecord, QSortBy> {
  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      sortByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      sortByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      sortByIntervalRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalRestSeconds', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      sortByIntervalRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalRestSeconds', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      sortByIntervalRounds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalRounds', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      sortByIntervalRoundsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalRounds', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      sortByIntervalWorkSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalWorkSeconds', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      sortByIntervalWorkSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalWorkSeconds', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> sortByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> sortByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> sortByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> sortByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension CardioRecordQuerySortThenBy
    on QueryBuilder<CardioRecord, CardioRecord, QSortThenBy> {
  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      thenByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      thenByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      thenByIntervalRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalRestSeconds', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      thenByIntervalRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalRestSeconds', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      thenByIntervalRounds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalRounds', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      thenByIntervalRoundsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalRounds', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      thenByIntervalWorkSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalWorkSeconds', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy>
      thenByIntervalWorkSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalWorkSeconds', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension CardioRecordQueryWhereDistinct
    on QueryBuilder<CardioRecord, CardioRecord, QDistinct> {
  QueryBuilder<CardioRecord, CardioRecord, QDistinct>
      distinctByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMinutes');
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QDistinct>
      distinctByIntervalRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalRestSeconds');
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QDistinct>
      distinctByIntervalRounds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalRounds');
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QDistinct>
      distinctByIntervalWorkSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalWorkSeconds');
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QDistinct> distinctByMemo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QDistinct> distinctByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mode');
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QDistinct> distinctBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId');
    });
  }

  QueryBuilder<CardioRecord, CardioRecord, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension CardioRecordQueryProperty
    on QueryBuilder<CardioRecord, CardioRecord, QQueryProperty> {
  QueryBuilder<CardioRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CardioRecord, int, QQueryOperations> durationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMinutes');
    });
  }

  QueryBuilder<CardioRecord, int?, QQueryOperations>
      intervalRestSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalRestSeconds');
    });
  }

  QueryBuilder<CardioRecord, int?, QQueryOperations> intervalRoundsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalRounds');
    });
  }

  QueryBuilder<CardioRecord, int?, QQueryOperations>
      intervalWorkSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalWorkSeconds');
    });
  }

  QueryBuilder<CardioRecord, String?, QQueryOperations> memoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memo');
    });
  }

  QueryBuilder<CardioRecord, CardioRecordMode, QQueryOperations>
      modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mode');
    });
  }

  QueryBuilder<CardioRecord, int, QQueryOperations> sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<CardioRecord, CardioType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
