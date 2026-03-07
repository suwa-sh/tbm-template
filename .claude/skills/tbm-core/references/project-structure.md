# プロジェクト構成

```
tbm-template/
├── compose.yml                 # Docker Compose設定（postgres, elt, grafana）
├── Dockerfile.dev              # ELTコンテナ用Dockerfile
├── requirements.txt            # Python依存パッケージ（dbt-postgres, dlt[postgres]）
├── dbt/
│   ├── files/
│   │   └── profiles.yml        # dbt接続プロファイル
│   └── src/
│       ├── dbt_project.yml     # dbtプロジェクト設定
│       ├── seeds/              # CSVシードデータ（マスター、配賦ルール、実績）
│       ├── models/
│       │   ├── staging/        # ステージングビュー（stg__*.sql）
│       │   ├── core/
│       │   │   └── cost_allocation/  # 配賦計算モデル
│       │   └── marts/
│       │       ├── finance/    # 財務視点の集計
│       │       ├── it/         # IT視点の集計
│       │       └── business/   # ビジネス視点の集計
│       └── tests/              # 整合性チェック
├── dlt/
│   ├── main.py                 # dltメインスクリプト
│   └── connectors/             # データソースコネクタ
│       ├── salesforce/         # Salesforceコネクタ（モック）
│       ├── sap/                # SAPコネクタ（モック）
│       ├── ms365/              # MS365コネクタ（モック）
│       └── crm/                # CRMコネクタ（モック）
├── grafana/
│   └── provisioning/
│       ├── datasources/
│       │   └── postgres.yaml   # PostgreSQL接続設定
│       └── dashboards/
│           ├── dashboards.yaml # ダッシュボードプロビジョニング設定
│           └── json/           # ダッシュボードJSON（8ファイル）
└── .dlt/
    └── secrets.toml            # dlt接続設定
```

## コンテナ構成

| コンテナ | ポート | 用途 |
|---------|--------|------|
| postgres | 5432 | PostgreSQL 15（tbm_db） |
| elt | 8080 | dbt + dlt 実行環境 |
| grafana | 3000 | Grafanaダッシュボード（admin/admin） |

## dbt モデルのマテリアライゼーション

| レイヤー | マテリアライゼーション | スキーマ |
|---------|----------------------|---------|
| seeds | table | raw |
| staging | view | デフォルト |
| core | table | デフォルト |
| marts | table | デフォルト |
