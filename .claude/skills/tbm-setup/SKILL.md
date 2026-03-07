---
name: tbm-setup
description: "TBM Templateの初期セットアップを支援します。Docker Compose環境の構築、サンプルデータのロード、Grafanaダッシュボードの動作確認、トラブルシューティングを行います。「セットアップ」「環境構築」「初期設定」「docker compose up」「TBMを始めたい」「dbt seedを実行」「Grafanaが表示されない」「コンテナが起動しない」「ポートが競合」「TBM環境を立ち上げ」などのキーワードで発動します。"
argument-hint: "セットアップの状況や困っていること（例: 「最初から環境構築したい」「dbt seedでエラーが出る」）"
---

# TBM Template セットアップ支援

Docker Compose環境の構築からサンプルデータのロード、動作確認までをガイドします。

## 共有リソース

- プロジェクト構成: `../tbm-core/references/project-structure.md`
- dbtコマンド: `../tbm-core/references/dbt-commands.md`

## 前提条件

- Docker Desktop がインストール済みであること
- Git がインストール済みであること
- ポート 5432（PostgreSQL）、8080（ELT）、3000（Grafana）が空いていること

## ワークフロー

### Step 1: 状況の確認

ユーザーの状況を確認する:

- **新規セットアップ**: リポジトリのクローンから始める
- **再セットアップ**: 既存環境のリセット（`docker compose down -v` → 再構築）
- **途中からの再開**: 特定のステップで止まっている
- **トラブルシューティング**: エラーが発生している

### Step 2: リポジトリの取得（新規の場合）

```bash
git clone https://github.com/suwa-sh/tbm-template.git
cd tbm-template
```

### Step 3: Docker環境の構築・起動

```bash
# イメージのビルド
docker compose build

# コンテナの起動
docker compose up -d
```

起動後、以下の3コンテナが running であることを確認:

```bash
docker compose ps
```

| コンテナ | ポート | 用途 |
|---------|--------|------|
| postgres | 5432 | PostgreSQL 15（tbm_db） |
| elt | 8080 | dbt + dlt 実行環境 |
| grafana | 3000 | Grafanaダッシュボード |

### Step 4: サンプルデータのロード

```bash
docker exec -it elt bash -c "cd /app/dbt/src && dbt seed --full-refresh && dbt run --full-refresh && dbt test"
```

各コマンドの役割:
- `dbt seed --full-refresh`: CSVシードデータをPostgreSQLにロード
- `dbt run --full-refresh`: 配賦計算モデルとマートを構築
- `dbt test`: データの整合性チェック

### Step 5: 動作確認

1. **Grafana**: http://localhost:3000 にアクセス（admin / admin）
2. **ダッシュボード**: Dashboards メニューから各ダッシュボードを開く
3. **データ確認**: 全社コストダッシュボードにグラフが表示されていればOK

### Step 6: 結果の提示

セットアップ完了をユーザーに報告し、次のステップを案内する:

- データのカスタマイズ → `tbm-customize` スキル
- dbtモデルの拡張 → `tbm-model` スキル
- ダッシュボードの追加 → `tbm-dashboard` スキル
- 外部データ収集 → `tbm-connector` スキル

## トラブルシューティング

### ポート競合

```bash
# 使用中のポートを確認
lsof -i :5432
lsof -i :3000
lsof -i :8080
```

競合がある場合、該当プロセスを停止するか、`compose.yml` のポートマッピングを変更する。

### コンテナが起動しない

```bash
# ログを確認
docker compose logs postgres
docker compose logs elt
docker compose logs grafana
```

よくある原因:
- Docker Desktop が起動していない
- ディスク容量不足
- 古いボリュームデータとの不整合 → `docker compose down -v` で volumes を削除して再起動

### dbt seed / run でエラー

```bash
# ELTコンテナ内で個別に実行して切り分け
docker exec -it elt bash
cd /app/dbt/src

# seedだけ実行
dbt seed --full-refresh

# 特定モデルだけ実行
dbt run --select model_name

# デバッグ出力
dbt run --full-refresh --debug
```

よくある原因:
- PostgreSQL コンテナが未起動 → `docker compose ps` で確認
- CSVファイルの書式エラー（カンマ、改行、クォートの問題）
- モデル間の依存関係エラー → `dbt run --full-refresh` で全モデルを再構築

### Grafana にデータが表示されない

1. dbt run が正常完了しているか確認
2. PostgreSQL にデータが入っているか確認:
   ```bash
   docker exec -it elt bash -c "cd /app/dbt/src && dbt show --select company_cost_history --limit 5"
   ```
3. Grafana のデータソース設定を確認（通常はプロビジョニング済みで変更不要）

### 環境のリセット

データを含めて完全にリセットしたい場合:

```bash
docker compose down -v
rm -rf container_data/
docker compose build --no-cache
docker compose up -d
```

## 注意事項

- devcontainer として利用する場合は、VS Code の「Reopen in Container」で elt コンテナに接続できる
- `container_data/` はボリュームマウント先で `.gitignore` 済み
- 初回の `docker compose build` はイメージダウンロードのため時間がかかる場合がある
