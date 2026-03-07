---
name: tbm-dashboard
description: "TBM TemplateのGrafanaダッシュボードの追加・編集を支援します。新しいダッシュボードの作成、既存ダッシュボードへのパネル追加、SQLクエリの作成、可視化の調整を行います。「ダッシュボードを追加」「Grafanaパネルを作成」「グラフを追加」「可視化を変更」「ダッシュボードを編集」「TBMの可視化」などのキーワードで発動します。"
argument-hint: "追加・変更するダッシュボードの説明（例: 「部門別の月次コスト推移グラフを追加したい」）"
---

# TBM Template ダッシュボード管理

Grafanaダッシュボード（JSON）を追加・編集して、TBMデータの可視化を拡張します。

## 共有リソース

- データモデル: `../tbm-core/references/data-model.md`
- プロジェクト構成: `../tbm-core/references/project-structure.md`

## ダッシュボード配置先

`grafana/provisioning/dashboards/json/` 配下にJSONファイルとして配置。
`grafana/provisioning/dashboards/dashboards.yaml` でプロビジョニング設定済み。

## 既存ダッシュボード

| ファイル | 視点 | 参照マート |
|---------|------|-----------|
| `business_company.json` | 全社コスト概要 | company_cost_history |
| `business_unit.json` | 部門別コスト | business_unit_cost_history |
| `business_capability.json` | ケイパビリティ別 | capability_cost_history |
| `it_tower.json` | ITタワー別 | tower_cost_history |
| `it_service.json` | サービス別 | service_cost_history |
| `finance_cost_pool.json` | コストプール別 | cost_pool_history |
| `allocation_business.json` | ビジネス配賦内訳 | service_to_business |
| `allocation_capability.json` | ケイパビリティ配賦内訳 | service_to_capability |

## ワークフロー

### Step 1: 要件の確認

ユーザーの要望から、以下を特定する:

- 新規ダッシュボードか、既存への追加か
- どのデータ（マート/ビュー）を可視化するか
- チャートタイプ（時系列、棒グラフ、円グラフ、テーブル等）
- フィルタ/変数の要否

### Step 2: 既存ダッシュボードの確認

参考にする既存ダッシュボードJSONを読み取り、以下を把握する:

- パネルの構造（gridPos, type, targets）
- SQLクエリのパターン
- テンプレート変数の使い方
- ダッシュボード間リンクの設定

### Step 3: SQLクエリの作成

PostgreSQLに対するSQLクエリを作成する。ポイント:

- テーブル名は dbt のマテリアライズ先を使用（スキーマは通常デフォルト）
- seeds は `raw` スキーマに配置される（例: `raw.master__business_units`）
- time カラムがある場合は Grafana の `$__timeFilter(time)` マクロを使用
- テンプレート変数は `$variable_name` で参照

### Step 4: ダッシュボードJSONの作成・編集

**新規ダッシュボードの場合:**
- 既存ダッシュボードをベースにJSONを作成
- `uid` を一意に設定
- `title` をわかりやすく設定

**既存ダッシュボードへのパネル追加の場合:**
- 既存JSONを読み取り、`panels` 配列にパネルを追加
- `gridPos` で配置位置を調整（h: 高さ, w: 幅, x: 横位置, y: 縦位置）
- `id` を既存パネルと重複しない値に設定

### Step 5: プロビジョニング設定の確認

新規ダッシュボードの場合、`grafana/provisioning/dashboards/dashboards.yaml` の設定で自動的にロードされることを確認（通常、json/ ディレクトリ配下は自動検出）。

### Step 6: 検証

```bash
# Grafanaコンテナの再起動でプロビジョニングを反映
docker compose restart grafana
```

Grafana（http://localhost:3000、admin/admin）でダッシュボードを確認する。

### Step 7: 結果の提示

追加・変更したダッシュボードの内容と確認方法をユーザーに提示する。

## 注意事項

- ダッシュボードJSONは大きいため、パネル追加時は既存構造を壊さないよう注意
- Grafanaで直接編集してからJSONをエクスポートする方法も有効（手動操作が必要）
- プロビジョニング経由のダッシュボードはGrafana UI上での保存ができない（JSONファイルを直接編集する必要がある）
- 円グラフには `grafana-piechart-panel` プラグインが必要（compose.yml で設定済み）
