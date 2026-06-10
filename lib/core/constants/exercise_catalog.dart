import 'package:progressive_lift/core/enums/muscle_group.dart';

class ExerciseTemplate {
  const ExerciseTemplate({
    required this.key,
    required this.name,
    required this.muscleGroup,
  });

  final String key;
  final String name;
  final MuscleGroup muscleGroup;
}

class ExerciseCatalog {
  /// 器具・バリエーションが自明な種目のみ（曖昧な名称はカスタム登録へ）
  static const templates = [
    // 胸
    ExerciseTemplate(key: 'bench_press', name: 'ベンチプレス', muscleGroup: MuscleGroup.chest),
    ExerciseTemplate(key: 'dips', name: 'ディップス', muscleGroup: MuscleGroup.chest),
    // 背中
    ExerciseTemplate(key: 'deadlift', name: 'デッドリフト', muscleGroup: MuscleGroup.back),
    ExerciseTemplate(key: 'barbell_row', name: 'バーベルロー', muscleGroup: MuscleGroup.back),
    ExerciseTemplate(key: 'chin_up', name: 'チンニング', muscleGroup: MuscleGroup.back),
    ExerciseTemplate(key: 'lat_pulldown', name: 'ラットプルダウン', muscleGroup: MuscleGroup.back),
    // 脚
    ExerciseTemplate(key: 'squat', name: 'スクワット', muscleGroup: MuscleGroup.legs),
    ExerciseTemplate(key: 'leg_press', name: 'レッグプレス', muscleGroup: MuscleGroup.legs),
    ExerciseTemplate(key: 'rdl', name: 'ルーマニアンデッドリフト', muscleGroup: MuscleGroup.legs),
    // 肩
    ExerciseTemplate(key: 'barbell_ohp', name: 'バーベルショルダープレス', muscleGroup: MuscleGroup.shoulders),
    // 腕
    ExerciseTemplate(key: 'barbell_curl', name: 'バーベルカール', muscleGroup: MuscleGroup.arms),
    // 体幹
    ExerciseTemplate(key: 'plank', name: 'プランク', muscleGroup: MuscleGroup.core),
  ];

  static ExerciseTemplate? findByKey(String key) {
    for (final t in templates) {
      if (t.key == key) return t;
    }
    // 旧キーとの互換
    const legacy = {
      'row': 'barbell_row',
      'ohp': 'barbell_ohp',
    };
    final mapped = legacy[key];
    if (mapped != null) return findByKey(mapped);
    return null;
  }

  static List<ExerciseTemplate> byMuscleGroup(MuscleGroup group) {
    return templates.where((t) => t.muscleGroup == group).toList();
  }

  static List<ExerciseTemplate> search(String query) {
    if (query.trim().isEmpty) return templates;
    final q = query.trim().toLowerCase();
    return templates
        .where((t) =>
            t.name.toLowerCase().contains(q) ||
            t.muscleGroup.label.contains(query))
        .toList();
  }
}
