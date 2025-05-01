"""
独自開発CRMシステムからデータを収集するパイプライン
"""

import dlt
from typing import Dict, List, Any, Iterator
from .mock_data import generate_mock_data

@dlt.source
def crm_source(api_key: str = None):
    """
    独自開発CRMシステムからデータを収集するソース
    
    Args:
        api_key: CRM APIキー（モックモードでは不要）
    """
    # モックデータを一度だけ取得
    mock_data = generate_mock_data()
    
    # リソースを明示的に定義して返す
    yield dlt.resource(
        [user for user in mock_data["users"]], 
        name="users"
    )
    
    yield dlt.resource(
        [module for module in mock_data["modules"]], 
        name="modules"
    )
    
    # インフラ情報は単一のオブジェクト
    yield dlt.resource(
        [mock_data["infrastructure"]],  # リストにラップして渡す
        name="infrastructure"
    )
    
    # 使用状況メトリクスをフラット化
    usage_metrics = []
    metrics_data = mock_data["usage_metrics"]
    
    for category, category_data in metrics_data.items():
        # 総計メトリクス
        metric_value = category_data.get("total") 
        if category == "storage":
            metric_value = category_data.get("total_gb")
            
        usage_metrics.append({
            "metric_name": f"{category}_total",
            "category": category,
            "department": None,
            "value": metric_value,
            "collected_at": "2025-04-30"  # メタデータ: 収集日
        })
        
        # 部門別メトリクス
        if "by_department" in category_data:
            for dept, value in category_data["by_department"].items():
                usage_metrics.append({
                    "metric_name": f"{category}_by_dept",
                    "category": category,
                    "department": dept,
                    "value": value,
                    "collected_at": "2025-04-30"  # メタデータ: 収集日
                })
    
    yield dlt.resource(
        usage_metrics,
        name="usage_metrics"
    )

if __name__ == "__main__":
    # パイプラインの実行
    pipeline = dlt.pipeline(
        pipeline_name="crm_data",
        destination="postgres",
        dataset_name="crm"
    )
    
    # データのロード
    load_info = pipeline.run(crm_source())
    print(f"CRMデータのロード結果: {load_info}")
