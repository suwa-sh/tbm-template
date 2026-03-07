# dbt コマンドリファレンス

## 実行環境

```bash
# ELTコンテナに入る
docker exec -it elt bash

# 作業ディレクトリ
cd /app/dbt/src
```

環境変数は compose.yml で設定済み:
- `DBT_PROFILES_DIR=/app/dbt/files`
- `DBT_PROJECT_DIR=/app/dbt/src`

## 基本コマンド

```bash
# シードデータのロード（CSV → DB）
dbt seed --full-refresh

# モデルの実行（変換・配賦計算）
dbt run --full-refresh

# テストの実行
dbt test

# ドキュメント生成・閲覧
dbt docs generate
dbt docs serve
```

## 選択的実行

```bash
# 特定モデルのみ実行
dbt run --select model_name

# ディレクトリ配下をすべて実行
dbt run --select path:models/marts/business

# 特定モデルとその上流を実行
dbt run --select +model_name

# 特定モデルとその下流を実行
dbt run --select model_name+
```

## シード更新の流れ

CSVを編集した後:

```bash
dbt seed --full-refresh    # CSVを再ロード
dbt run --full-refresh     # モデルを再計算
dbt test                   # 整合性チェック
```
