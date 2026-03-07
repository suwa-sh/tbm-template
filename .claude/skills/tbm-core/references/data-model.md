# TBM Template データモデル

## 配賦フロー

```
コストプール → ITタワー → テクノロジーサービス → ビジネスユニット
                                               → ビジネスケイパビリティ
```

各ステップは配賦ルール（allocation_value: 0.0〜1.0）で按分される。

## シードCSV一覧

### TBMタクソノミーマスター（基本変更不要）

| ファイル | 内容 | 主キー |
|---------|------|--------|
| `master_tbm__cost_pools.csv` | コストプール定義 | cost_pool_id |
| `master_tbm__cost_sub_pools.csv` | コストサブプール定義 | cost_sub_pool_id |
| `master_tbm__it_towers.csv` | ITタワー定義 | it_tower_id |
| `master_tbm__it_sub_towers.csv` | ITサブタワー定義 | it_sub_tower_id |

### 組織固有マスター

| ファイル | 内容 | 主キー | 備考 |
|---------|------|--------|------|
| `master__it_services.csv` | ITサービス定義 | service_id | service_type: business_solution, workplace_solution等 |
| `master__business_units.csv` | 部門定義 | business_unit_id | 年度×月ごと、parent_idで階層 |
| `master__business_capabilities.csv` | ビジネスケイパビリティ定義 | capability_id | capability_type: strategic, core, support, governance |

### 配賦ルール

| ファイル | 配賦元 → 配賦先 | キー列 |
|---------|----------------|--------|
| `allocations__cost_to_tower.csv` | コストプール → ITタワー | fiscal_year, fiscal_month, cost_pool_id, cost_sub_pool_id, it_tower_id, it_sub_tower_id |
| `allocations__tower_to_service.csv` | ITタワー → サービス | fiscal_year, fiscal_month, it_tower_id, it_sub_tower_id, service_id |
| `allocations__service_to_business.csv` | サービス → 部門 | fiscal_year, fiscal_month, service_id, business_unit_id |
| `allocations__service_to_capability.csv` | サービス → ケイパビリティ | fiscal_year, fiscal_month, service_id, capability_id |

共通列:
- `allocation_method`: direct, usage_based, even_split等
- `allocation_value`: 0.0〜1.0の配賦比率
- `description`: 配賦理由の説明

### 実績・予算データ

| ファイル | 内容 | キー列 |
|---------|------|--------|
| `entries_cost.csv` | コスト実績 | fiscal_year, fiscal_month, cost_pool_id, cost_sub_pool_id |
| `entries_plan.csv` | 予算データ | fiscal_year, fiscal_month |

entries_cost.csv の列: vendor, description, amount

## dbt モデル構成

### staging（view）
- `stg__entries_cost`, `stg__entries_plan`: 実績/予算のステージング
- `stg__master_tbm__*`: TBMマスターのステージング
- `stg__master__*`: 組織マスターのステージング
- `stg__allocations__*`: 配賦ルールのステージング

### core（table） - 配賦計算
- `cost_to_tower`: コストプール → ITタワー（amount × allocation_value）
- `tower_to_service`: ITタワー → テクノロジーサービス
- `service_to_business`: テクノロジーサービス → ビジネスユニット
- `service_to_capability`: テクノロジーサービス → ビジネスケイパビリティ

### marts（table） - 集計ビュー
- `finance/cost_pool_history`: コストプール別の履歴
- `it/tower_cost_history`: ITタワー別コスト履歴
- `it/service_cost_history`: サービス別コスト履歴
- `business/business_unit_cost_history`: 部門別コスト履歴
- `business/company_cost_history`: 全社コスト履歴（予実比較、従業員あたりコスト）
- `business/capability_cost_history`: ケイパビリティ別コスト履歴

## Grafana ダッシュボード

| ファイル | 視点 |
|---------|------|
| `business_company.json` | 全社コスト概要 |
| `business_unit.json` | 部門別コスト |
| `business_capability.json` | ケイパビリティ別コスト |
| `it_tower.json` | ITタワー別コスト |
| `it_service.json` | サービス別コスト |
| `finance_cost_pool.json` | コストプール別 |
| `allocation_business.json` | ビジネス配賦内訳 |
| `allocation_capability.json` | ケイパビリティ配賦内訳 |

配置先: `grafana/provisioning/dashboards/json/`
