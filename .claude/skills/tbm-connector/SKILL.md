---
name: tbm-connector
description: "TBM Templateのdltコネクタの追加・カスタマイズを支援します。新しい外部サービスからのデータ収集パイプラインの構築、既存コネクタのモックから実APIへの変更、データソース追加を行います。「コネクタを追加」「データ収集を設定」「dltパイプラインを作成」「外部サービスを接続」「APIからデータを取得」「モックを実データに変更」「新しいデータソース」「TBMデータ収集」などのキーワードで発動します。"
argument-hint: "追加・変更するコネクタの説明（例: 「AWS Cost Explorerからコストデータを収集したい」）"
---

# TBM Template dltコネクタ管理

dltコネクタ（Python）を追加・カスタマイズして、外部サービスからのデータ収集を拡張します。

## 共有リソース

- データモデル: `../tbm-core/references/data-model.md`
- プロジェクト構成: `../tbm-core/references/project-structure.md`

## コネクタ配置先

```
dlt/
├── main.py                 # メインスクリプト（全コネクタを実行）
└── connectors/
    ├── salesforce/          # 既存: Salesforceコネクタ
    │   ├── pipeline.py     # dlt source定義
    │   └── mock_data.py    # モックデータ生成
    ├── sap/                # 既存: SAPコネクタ
    ├── ms365/              # 既存: MS365コネクタ
    └── crm/                # 既存: CRMコネクタ
```

## ワークフロー

### Step 1: 要件の確認

ユーザーの要望から、以下を特定する:

- 接続先サービス（API仕様、認証方式）
- 収集するデータの種類（ユーザー、ライセンス、利用状況、コスト等）
- 収集データの用途（配賦の入力にするか、参考情報か）

### Step 2: 既存コネクタの確認

既存コネクタ（例: `dlt/connectors/salesforce/`）を参考に、パターンを把握する:

- `pipeline.py`: `@dlt.source` デコレータでソースを定義、`dlt.resource()` でリソースを yield
- `mock_data.py`: 開発用モックデータの生成
- `main.py`: `available_sources` にコネクタを登録

### Step 3: コネクタの作成

**新規コネクタのファイル構成:**

```
dlt/connectors/{service_name}/
├── __init__.py        # 空ファイル
├── pipeline.py        # dlt source/resource定義
└── mock_data.py       # モックデータ（開発用）
```

**pipeline.py のパターン:**

```python
import dlt
from .mock_data import generate_mock_data

@dlt.source
def {service_name}_source(api_key: str = None):
    mock_data = generate_mock_data()

    yield dlt.resource(
        mock_data["resource_name"],
        name="resource_name"
    )
```

**実API接続の場合:**

```python
import dlt
import requests

@dlt.source
def {service_name}_source(api_key: str = dlt.secrets.value):
    @dlt.resource
    def items():
        response = requests.get(
            "https://api.example.com/items",
            headers={"Authorization": f"Bearer {api_key}"}
        )
        yield from response.json()

    return items
```

### Step 4: main.py への登録

`dlt/main.py` の `available_sources` に新しいコネクタを追加する。

```python
from connectors.{service_name}.pipeline import {service_name}_source

available_sources = {
    # 既存のソース...
    "{service_name}": {service_name}_source,
}
```

### Step 5: シークレットの設定（実API接続の場合）

`.dlt/secrets.toml` にAPI キー等を追加する。

```toml
[sources.{service_name}]
api_key = "your-api-key"
```

### Step 6: 検証

```bash
docker exec -it elt bash
cd /app

# 特定のコネクタのみ実行
python ./dlt/main.py --sources {service_name}

# 全コネクタを実行
python ./dlt/main.py
```

### Step 7: 結果の提示

作成・変更したコネクタの内容と、収集されるデータの概要をユーザーに提示する。
収集データを配賦に活用する場合は、dbtモデルの追加も提案する。

## 注意事項

- 現在のコネクタはすべてモックデータを使用しており、配賦には直接利用されていない
- 実APIに接続する場合は、APIキー等のシークレットを `.dlt/secrets.toml` に設定する（Gitにコミットしないこと）
- dlt は PostgreSQL の別スキーマ（`dataset_name` で指定）にデータをロードする
- 収集データを配賦に活用するには、dbtモデル側でそのテーブルを参照する拡張が別途必要
