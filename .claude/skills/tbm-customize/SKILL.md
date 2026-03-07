---
name: tbm-customize
description: "TBM Templateの配賦ルール・マスターデータ・コストデータのカスタマイズを支援します。CSVシードファイルの編集、新しい部門やサービスの追加、配賦比率の変更、コストデータの追加・更新などを行います。「配賦ルールを変更」「部門を追加」「コストデータを更新」「サービスを追加」「ビジネスケイパビリティを追加」「予算データを編集」「シードを更新」「TBMデータをカスタマイズ」などのキーワードで発動します。"
argument-hint: "変更内容の説明（例: 「マーケティング部門を追加したい」「ERPの配賦比率を変更したい」）"
---

# TBM Template データカスタマイズ

CSVシードファイルを編集して、TBM Templateのデータをカスタマイズします。

## 共有リソース

- データモデル: `../tbm-core/references/data-model.md`
- dbtコマンド: `../tbm-core/references/dbt-commands.md`
- プロジェクト構成: `../tbm-core/references/project-structure.md`

## 対象ファイル

すべて `dbt/src/seeds/` 配下のCSVファイル:

- **組織マスター**: `master__business_units.csv`, `master__it_services.csv`, `master__business_capabilities.csv`
- **配賦ルール**: `allocations__cost_to_tower.csv`, `allocations__tower_to_service.csv`, `allocations__service_to_business.csv`, `allocations__service_to_capability.csv`
- **実績/予算**: `entries_cost.csv`, `entries_plan.csv`

## ワークフロー

### Step 1: 変更内容の確認

ユーザーの要望を確認し、どのCSVファイルを編集するか特定する。
データモデルの詳細は `../tbm-core/references/data-model.md` を参照。

### Step 2: 現在のデータを読み取り

対象CSVファイルを読み取り、既存データの構造と値を把握する。

### Step 3: CSVファイルの編集

以下のルールに従って編集する:

- **IDの命名規則**: スネークケース（英字小文字 + アンダースコア）
- **年度/月の整合性**: 既存データと同じ fiscal_year, fiscal_month の組み合わせに合わせる
- **配賦比率の合計**: 同じ配賦元から出る allocation_value の合計が 1.0 になるようにする
- **マスターとの整合性**: 配賦ルールのIDは、対応するマスターCSVに存在するIDを使用する
- **部門の階層**: `master__business_units.csv` の parent_id で親子関係を表現。親部門の employee_count は子部門の合計

### Step 4: 関連ファイルの連鎖更新

変更の影響範囲を確認し、関連ファイルも更新する:

- マスターを追加 → 対応する配賦ルールも追加が必要
- 配賦元を変更 → 下流の配賦ルールの比率調整が必要
- 年度を追加 → 全マスターと配賦ルールに新年度分を追加

### Step 5: 検証

```bash
docker exec -it elt bash
cd /app/dbt/src
dbt seed --full-refresh
dbt run --full-refresh
dbt test
```

テスト結果を確認し、エラーがあれば修正する。

### Step 6: 結果の確認

変更内容のサマリーをユーザーに提示する。
Grafana（http://localhost:3000）での確認を推奨。

## 注意事項

- `master_tbm__*.csv`（TBMタクソノミー）は基本的に変更不要
- 配賦比率の合計が1.0にならない場合、配賦されないコストが発生する
- 年度をまたぐデータは、各年度ごとにマスターと配賦ルールが必要
- 大きな変更は段階的に行い、各ステップでテストを実行することを推奨
