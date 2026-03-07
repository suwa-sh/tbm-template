---
name: tbm-core
description: "TBM Templateの共有リソースを提供する内部スキルです。他のtbm系スキルから参照されます。直接トリガーされることは想定していません。"
user-invokable: false
---

# TBM Template 共有リソース

TBM（Technology Business Management）テンプレートプロジェクトの共有リソースを提供します。
Docker Compose上でdbt/dlt/Grafana/PostgreSQLを使い、ITコストの配賦と可視化を行うテンプレートです。

## 提供リソース

### references/

- `data-model.md`: シードCSVのスキーマ定義、配賦フローの全体像
- `dbt-commands.md`: dbt操作のクイックリファレンス
- `project-structure.md`: プロジェクトのディレクトリ構成と各ファイルの役割

### 参照方法

他のtbmスキルから以下のように参照してください:

```
../tbm-core/references/data-model.md
../tbm-core/references/dbt-commands.md
../tbm-core/references/project-structure.md
```
