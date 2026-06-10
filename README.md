# Progressive Lift

プログレッシブオーバーロード（漸進性過負荷）の可視化に特化した筋トレ管理アプリ。

## ディレクトリ構成

```
lib/
├── main.dart                 # エントリポイント
├── app.dart                  # MaterialApp / ProviderScope
├── core/                     # 横断的関心事
│   ├── constants/            # 種目カタログ等
│   ├── enums/                # MuscleGroup
│   └── theme/
├── data/                     # データ層
│   ├── local/                # Isar初期化・シード
│   ├── models/               # Isar @collection モデル
│   └── repositories/         # CRUD・集計クエリ
├── domain/                   # ビジネスロジック層
│   ├── models/               # TopSetPoint, WorkoutTarget
│   └── services/             # 抽出・サブスク・AIスタブ
├── features/                 # UI層（機能単位）
│   ├── calendar/
│   ├── workout/
│   └── exercise_detail/
├── providers/                # Riverpod DI
└── shared/widgets/           # 共通ウィジェット
```

## セットアップ

```bash
cd progressive_lift
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## 技術スタック

- Flutter + hooks_riverpod + riverpod_annotation
- Isar（ローカルDB）
- table_calendar / fl_chart
