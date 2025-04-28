# TBM Template

TBM（Technology Business Management）を小さく始めるためのテンプレートプロジェクトです。

## 概要

このプロジェクトは、TBMの基本的な構成要素を含み、Docker Composeを使って簡単に環境を構築できるようになっています。以下のコンポーネントが含まれています：

- **PostgreSQL**: データベース
- **dbt**: データパイプライン
- **dlt**: データ収集
- **Grafana**: 可視化

## 前提条件

- Docker と Docker Compose がインストールされていること
- Git がインストールされていること

## セットアップ方法

### 1. リポジトリのクローン

```bash
git clone https://github.com/your-username/tbm-template.git
cd tbm-template
```

### 2. 環境の起動

```bash
docker compose up -d
```

これにより、必要なコンテナがすべて起動します。

### 3. サンプルデータのロード

```bash
# dbtコンテナに入る
docker exec -it tbm-dbt bash

# サンプルデータをロード
cd /app/dbt/src
dbt seed
dbt run

# コンテナから出る
exit
```

### 4. Grafanaへのアクセス

ブラウザで http://localhost:3000 にアクセスします。

- ユーザー名: admin
- パスワード: admin

## プロジェクト構成

```
tbm-template/
├── dbt/                    # データパイプライン
│   ├── files/              # dbt設定ファイル
│   └── src/                # dbtプロジェクト
│       ├── seeds/          # サンプルデータ
│       └── models/         # データモデル
├── dlt/                    # データ収集
│   └── connectors/         # 各種データソースコネクタ
├── grafana/                # 可視化
│   └── provisioning/       # Grafana設定
├── compose.yml             # Docker Compose設定
├── Dockerfile.dev          # 開発用Dockerfile
└── requirements.txt        # Pythonパッケージ
```

## カスタマイズ方法

### 配賦ルールのカスタマイズ

配賦ルールは以下のファイルで定義されています：

- `dbt/src/seeds/cost_to_tower_allocations.csv`: コストプールからITタワーへの配賦
- `dbt/src/seeds/tower_to_service_allocations.csv`: ITタワーからテクノロジーサービスへの配賦
- `dbt/src/seeds/service_to_business_allocations.csv`: テクノロジーサービスからビジネスユニットへの配賦
- `dbt/src/seeds/service_to_capability_allocations.csv`: テクノロジーサービスからビジネスケイパビリティへの配賦

これらのファイルを編集し、`dbt seed`コマンドを実行することで、配賦ルールを更新できます。

### 外部サービスからのデータ収集

`dlt/connectors/`ディレクトリには、以下の外部サービスからデータを収集するためのサンプルコードが含まれています：

- Salesforce
- SAP
- Microsoft 365
- 独自開発CRMシステム

これらのコネクタを実際の環境に合わせてカスタマイズし、`dlt/main.py`を実行することで、データを収集できます。

```bash
# dltコンテナに入る
docker exec -it tbm-dlt bash

# データ収集を実行
cd /app/dlt
python main.py

# コンテナから出る
exit
```

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。
