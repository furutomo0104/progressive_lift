// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarHash() => r'062eb77044052c6262c8fa63696534e9f562fd42';

/// See also [isar].
@ProviderFor(isar)
final isarProvider = FutureProvider<Isar>.internal(
  isar,
  name: r'isarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarRef = FutureProviderRef<Isar>;
String _$workoutRepositoryHash() => r'7b81b98c1af62f24a9b195fade9e920326a641c5';

/// See also [workoutRepository].
@ProviderFor(workoutRepository)
final workoutRepositoryProvider = FutureProvider<WorkoutRepository>.internal(
  workoutRepository,
  name: r'workoutRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkoutRepositoryRef = FutureProviderRef<WorkoutRepository>;
String _$subscriptionServiceHash() =>
    r'04e393852f53529a6a74b8e40eda96b12973375e';

/// See also [subscriptionService].
@ProviderFor(subscriptionService)
final subscriptionServiceProvider = Provider<SubscriptionService>.internal(
  subscriptionService,
  name: r'subscriptionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubscriptionServiceRef = ProviderRef<SubscriptionService>;
String _$aiSuggestServiceHash() => r'934f03f0edba6af1cd18b5ee8d11cc5bf24237c3';

/// See also [aiSuggestService].
@ProviderFor(aiSuggestService)
final aiSuggestServiceProvider = Provider<AiSuggestService>.internal(
  aiSuggestService,
  name: r'aiSuggestServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiSuggestServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AiSuggestServiceRef = ProviderRef<AiSuggestService>;
String _$topSetSeriesHash() => r'd52b887e7bd88927a62d68766a93e3436d907fdd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [topSetSeries].
@ProviderFor(topSetSeries)
const topSetSeriesProvider = TopSetSeriesFamily();

/// See also [topSetSeries].
class TopSetSeriesFamily extends Family<AsyncValue<List<TopSetPoint>>> {
  /// See also [topSetSeries].
  const TopSetSeriesFamily();

  /// See also [topSetSeries].
  TopSetSeriesProvider call(
    String exerciseKey,
  ) {
    return TopSetSeriesProvider(
      exerciseKey,
    );
  }

  @override
  TopSetSeriesProvider getProviderOverride(
    covariant TopSetSeriesProvider provider,
  ) {
    return call(
      provider.exerciseKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'topSetSeriesProvider';
}

/// See also [topSetSeries].
class TopSetSeriesProvider
    extends AutoDisposeFutureProvider<List<TopSetPoint>> {
  /// See also [topSetSeries].
  TopSetSeriesProvider(
    String exerciseKey,
  ) : this._internal(
          (ref) => topSetSeries(
            ref as TopSetSeriesRef,
            exerciseKey,
          ),
          from: topSetSeriesProvider,
          name: r'topSetSeriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$topSetSeriesHash,
          dependencies: TopSetSeriesFamily._dependencies,
          allTransitiveDependencies:
              TopSetSeriesFamily._allTransitiveDependencies,
          exerciseKey: exerciseKey,
        );

  TopSetSeriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseKey,
  }) : super.internal();

  final String exerciseKey;

  @override
  Override overrideWith(
    FutureOr<List<TopSetPoint>> Function(TopSetSeriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopSetSeriesProvider._internal(
        (ref) => create(ref as TopSetSeriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseKey: exerciseKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TopSetPoint>> createElement() {
    return _TopSetSeriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopSetSeriesProvider && other.exerciseKey == exerciseKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TopSetSeriesRef on AutoDisposeFutureProviderRef<List<TopSetPoint>> {
  /// The parameter `exerciseKey` of this provider.
  String get exerciseKey;
}

class _TopSetSeriesProviderElement
    extends AutoDisposeFutureProviderElement<List<TopSetPoint>>
    with TopSetSeriesRef {
  _TopSetSeriesProviderElement(super.provider);

  @override
  String get exerciseKey => (origin as TopSetSeriesProvider).exerciseKey;
}

String _$aiSuggestionHash() => r'2a0199c4c96abebae87cf092a5155c957364f55d';

/// See also [aiSuggestion].
@ProviderFor(aiSuggestion)
const aiSuggestionProvider = AiSuggestionFamily();

/// See also [aiSuggestion].
class AiSuggestionFamily extends Family<AsyncValue<String?>> {
  /// See also [aiSuggestion].
  const AiSuggestionFamily();

  /// See also [aiSuggestion].
  AiSuggestionProvider call(
    String exerciseKey,
  ) {
    return AiSuggestionProvider(
      exerciseKey,
    );
  }

  @override
  AiSuggestionProvider getProviderOverride(
    covariant AiSuggestionProvider provider,
  ) {
    return call(
      provider.exerciseKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'aiSuggestionProvider';
}

/// See also [aiSuggestion].
class AiSuggestionProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [aiSuggestion].
  AiSuggestionProvider(
    String exerciseKey,
  ) : this._internal(
          (ref) => aiSuggestion(
            ref as AiSuggestionRef,
            exerciseKey,
          ),
          from: aiSuggestionProvider,
          name: r'aiSuggestionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aiSuggestionHash,
          dependencies: AiSuggestionFamily._dependencies,
          allTransitiveDependencies:
              AiSuggestionFamily._allTransitiveDependencies,
          exerciseKey: exerciseKey,
        );

  AiSuggestionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseKey,
  }) : super.internal();

  final String exerciseKey;

  @override
  Override overrideWith(
    FutureOr<String?> Function(AiSuggestionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AiSuggestionProvider._internal(
        (ref) => create(ref as AiSuggestionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseKey: exerciseKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _AiSuggestionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiSuggestionProvider && other.exerciseKey == exerciseKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AiSuggestionRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `exerciseKey` of this provider.
  String get exerciseKey;
}

class _AiSuggestionProviderElement
    extends AutoDisposeFutureProviderElement<String?> with AiSuggestionRef {
  _AiSuggestionProviderElement(super.provider);

  @override
  String get exerciseKey => (origin as AiSuggestionProvider).exerciseKey;
}

String _$customExerciseTemplatesHash() =>
    r'6dfcd77e0dc4f629524e2d01d6fd3ef1fe120b90';

/// See also [customExerciseTemplates].
@ProviderFor(customExerciseTemplates)
final customExerciseTemplatesProvider =
    AutoDisposeFutureProvider<List<CustomExerciseTemplate>>.internal(
  customExerciseTemplates,
  name: r'customExerciseTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customExerciseTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CustomExerciseTemplatesRef
    = AutoDisposeFutureProviderRef<List<CustomExerciseTemplate>>;
String _$selectableExercisesHash() =>
    r'33b8e390b9358ee4fb7b059832b9bc70b7a165a3';

/// See also [selectableExercises].
@ProviderFor(selectableExercises)
final selectableExercisesProvider =
    AutoDisposeFutureProvider<List<SelectableExercise>>.internal(
  selectableExercises,
  name: r'selectableExercisesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectableExercisesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectableExercisesRef
    = AutoDisposeFutureProviderRef<List<SelectableExercise>>;
String _$exerciseNameHash() => r'029752e7a433db9efa4e9893f2b33fb3ea2d1c85';

/// See also [exerciseName].
@ProviderFor(exerciseName)
const exerciseNameProvider = ExerciseNameFamily();

/// See also [exerciseName].
class ExerciseNameFamily extends Family<AsyncValue<String>> {
  /// See also [exerciseName].
  const ExerciseNameFamily();

  /// See also [exerciseName].
  ExerciseNameProvider call(
    String exerciseKey,
  ) {
    return ExerciseNameProvider(
      exerciseKey,
    );
  }

  @override
  ExerciseNameProvider getProviderOverride(
    covariant ExerciseNameProvider provider,
  ) {
    return call(
      provider.exerciseKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exerciseNameProvider';
}

/// See also [exerciseName].
class ExerciseNameProvider extends AutoDisposeFutureProvider<String> {
  /// See also [exerciseName].
  ExerciseNameProvider(
    String exerciseKey,
  ) : this._internal(
          (ref) => exerciseName(
            ref as ExerciseNameRef,
            exerciseKey,
          ),
          from: exerciseNameProvider,
          name: r'exerciseNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exerciseNameHash,
          dependencies: ExerciseNameFamily._dependencies,
          allTransitiveDependencies:
              ExerciseNameFamily._allTransitiveDependencies,
          exerciseKey: exerciseKey,
        );

  ExerciseNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseKey,
  }) : super.internal();

  final String exerciseKey;

  @override
  Override overrideWith(
    FutureOr<String> Function(ExerciseNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExerciseNameProvider._internal(
        (ref) => create(ref as ExerciseNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseKey: exerciseKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _ExerciseNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseNameProvider && other.exerciseKey == exerciseKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExerciseNameRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `exerciseKey` of this provider.
  String get exerciseKey;
}

class _ExerciseNameProviderElement
    extends AutoDisposeFutureProviderElement<String> with ExerciseNameRef {
  _ExerciseNameProviderElement(super.provider);

  @override
  String get exerciseKey => (origin as ExerciseNameProvider).exerciseKey;
}

String _$calendarSummariesHash() => r'd1102dc5f44a8521a13100db8cfe6d2e9e9acc65';

/// See also [calendarSummaries].
@ProviderFor(calendarSummaries)
const calendarSummariesProvider = CalendarSummariesFamily();

/// See also [calendarSummaries].
class CalendarSummariesFamily
    extends Family<AsyncValue<Map<DateTime, DayWorkoutSummary>>> {
  /// See also [calendarSummaries].
  const CalendarSummariesFamily();

  /// See also [calendarSummaries].
  CalendarSummariesProvider call(
    DateTime monthAnchor,
  ) {
    return CalendarSummariesProvider(
      monthAnchor,
    );
  }

  @override
  CalendarSummariesProvider getProviderOverride(
    covariant CalendarSummariesProvider provider,
  ) {
    return call(
      provider.monthAnchor,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'calendarSummariesProvider';
}

/// See also [calendarSummaries].
class CalendarSummariesProvider
    extends AutoDisposeFutureProvider<Map<DateTime, DayWorkoutSummary>> {
  /// See also [calendarSummaries].
  CalendarSummariesProvider(
    DateTime monthAnchor,
  ) : this._internal(
          (ref) => calendarSummaries(
            ref as CalendarSummariesRef,
            monthAnchor,
          ),
          from: calendarSummariesProvider,
          name: r'calendarSummariesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calendarSummariesHash,
          dependencies: CalendarSummariesFamily._dependencies,
          allTransitiveDependencies:
              CalendarSummariesFamily._allTransitiveDependencies,
          monthAnchor: monthAnchor,
        );

  CalendarSummariesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.monthAnchor,
  }) : super.internal();

  final DateTime monthAnchor;

  @override
  Override overrideWith(
    FutureOr<Map<DateTime, DayWorkoutSummary>> Function(
            CalendarSummariesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalendarSummariesProvider._internal(
        (ref) => create(ref as CalendarSummariesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        monthAnchor: monthAnchor,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<DateTime, DayWorkoutSummary>>
      createElement() {
    return _CalendarSummariesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarSummariesProvider &&
        other.monthAnchor == monthAnchor;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, monthAnchor.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CalendarSummariesRef
    on AutoDisposeFutureProviderRef<Map<DateTime, DayWorkoutSummary>> {
  /// The parameter `monthAnchor` of this provider.
  DateTime get monthAnchor;
}

class _CalendarSummariesProviderElement
    extends AutoDisposeFutureProviderElement<Map<DateTime, DayWorkoutSummary>>
    with CalendarSummariesRef {
  _CalendarSummariesProviderElement(super.provider);

  @override
  DateTime get monthAnchor => (origin as CalendarSummariesProvider).monthAnchor;
}

String _$premiumToggleHash() => r'9ca71e85f74a82787014eadfaa87a718e2df0265';

/// See also [PremiumToggle].
@ProviderFor(PremiumToggle)
final premiumToggleProvider =
    AutoDisposeNotifierProvider<PremiumToggle, bool>.internal(
  PremiumToggle.new,
  name: r'premiumToggleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$premiumToggleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PremiumToggle = AutoDisposeNotifier<bool>;
String _$exerciseCatalogTickHash() =>
    r'c92053733795881eab560ffd9319e9b7d91b9bb8';

/// See also [ExerciseCatalogTick].
@ProviderFor(ExerciseCatalogTick)
final exerciseCatalogTickProvider =
    AutoDisposeNotifierProvider<ExerciseCatalogTick, int>.internal(
  ExerciseCatalogTick.new,
  name: r'exerciseCatalogTickProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exerciseCatalogTickHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExerciseCatalogTick = AutoDisposeNotifier<int>;
String _$calendarRefreshTickHash() =>
    r'7c355d1eeec04e9e824aa0858b3000ddfee797d2';

/// カレンダー再読み込み用（記録変更時に bump）
///
/// Copied from [CalendarRefreshTick].
@ProviderFor(CalendarRefreshTick)
final calendarRefreshTickProvider =
    AutoDisposeNotifierProvider<CalendarRefreshTick, int>.internal(
  CalendarRefreshTick.new,
  name: r'calendarRefreshTickProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calendarRefreshTickHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CalendarRefreshTick = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
