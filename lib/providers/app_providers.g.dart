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
    r'5d49f3376a47a63ab36618c9dcfbed8b69151608';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
