---
name: tbm-model
description: "TBM Templateのdbtモデルの追加・変更を支援します。新しい配賦ステップの追加、集計マートの作成、ステージングモデルの追加、既存モデルの拡張を行います。「dbtモデルを追加」「新しいマートを作成」「配賦ステップを追加」「集計モデルを変更」「ステージングを追加」「dbtのSQLを修正」「TBMモデルを拡張」などのキーワードで発動します。"
argument-hint: "追加・変更するモデルの説明（例: 「プロジェクト別コストのマートを追加したい」）"
---

# TBM Template dbtモデル管理

dbtモデル（SQL）を追加・変更して、TBM Templateの配賦ロジックや集計を拡張します。

## 共有リソース

- データモデル: `../tbm-core/references/data-model.md`
- dbtコマンド: `../tbm-core/references/dbt-commands.md`
- プロジェクト構成: `../tbm-core/references/project-structure.md`

## モデル配置先

```
dbt/src/models/
├── staging/        # stg__*.sql（view）- シードのステージング
├── core/
│   └── cost_allocation/  # 配賦計算（table）
└── marts/
    ├── finance/    # 財務視点の集計（table）
    ├── it/         # IT視点の集計（table）
    └── business/   # ビジネス視点の集計（table）
```

## ワークフロー

### Step 1: 要件の確認

ユーザーの要望から、以下を特定する:

- 新規モデルか既存モデルの変更か
- どのレイヤー（staging / core / marts）に配置するか
- 参照する上流モデルは何か
- 出力カラムと集計ロジック

### Step 2: 既存モデルの把握

関連する既存モデルを読み取り、以下を確認する:

- CTE（with句）の構成パターン
- ref() で参照しているモデル
- カラム名の命名規則
- 配賦計算のパターン（`amount * allocation_value as allocated_amount`）

### Step 3: モデルの作成・編集

既存パターンに従ってSQLを作成する:

**ステージングモデルのパターン:**
```sql
select * from {{ ref('seed_name') }}
```

**配賦モデルのパターン:**
```sql
with
source as (select * from {{ ref('upstream_model') }}),
allocations as (select * from {{ ref('stg__allocations__xxx') }}),
allocated as (
    select
        s.fiscal_year,
        s.fiscal_month,
        -- 配賦先のカラム
        a.allocation_method,
        a.allocation_value,
        s.amount * a.allocation_value as allocated_amount
    from source s
    inner join allocations a on s.key = a.key
)
select * from allocated
```

**マートモデルのパターン:**
```sql
with
source as (select * from {{ ref('core_or_upstream_model') }}),
aggregated as (
    select
        fiscal_year,
        fiscal_month,
        -- グループ化キー
        sum(allocated_amount) as total_allocated_amount
    from source
    group by 1, 2, ...
)
select * from aggregated
```

### Step 4: dbt_project.yml の確認

新しいディレクトリを追加した場合、`dbt/src/dbt_project.yml` の `models` セクションにマテリアライゼーション設定が必要か確認する。

### Step 5: テストの追加（必要な場合）

`dbt/src/tests/` にカスタムテストを追加する。特に配賦の合計値検証が重要。

### Step 6: 検証

```bash
docker exec -it elt bash
cd /app/dbt/src

# 新しいシードがある場合
dbt seed --full-refresh

# モデルの実行
dbt run --full-refresh

# テスト
dbt test

# lineage graphの確認
dbt docs generate
dbt docs serve
```

### Step 7: 結果の提示

作成・変更したモデルの一覧と、lineage上の位置づけをユーザーに提示する。

## 注意事項

- staging は必ず view、core/marts は table でマテリアライズする
- ref() マクロで上流モデルを参照し、テーブル名を直接書かない
- 配賦計算では inner join を使用（配賦ルールがないコストは配賦しない）
- fiscal_year, fiscal_month の結合条件を忘れないこと
