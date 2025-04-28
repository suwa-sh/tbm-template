"""
SAPからデータを収集するパイプライン
"""

import dlt
from typing import Dict, List, Any, Iterator
from .mock_data import generate_mock_data

@dlt.source
def sap_source(api_key: str = None) -> Dict[str, Any]:
    """
    SAPからデータを収集するソース
    
    Args:
        api_key: SAP APIキー（モックモードでは不要）
        
    Returns:
        Dict[str, Any]: リソースを含むソース定義
    """
    return {
        "users": users_resource(),
        "licenses": licenses_resource(),
        "modules": modules_resource(),
        "usage_metrics": usage_metrics_resource()
    }

@dlt.resource
def users_resource() -> Iterator[Dict[str, Any]]:
    """
    SAPのユーザー情報を取得するリソース
    
    Yields:
        Dict[str, Any]: ユーザー情報
    """
    mock_data = generate_mock_data()
    for user in mock_data["users"]:
        yield user

@dlt.resource
def licenses_resource() -> Iterator[Dict[str, Any]]:
    """
    SAPのライセンス情報を取得するリソース
    
    Yields:
        Dict[str, Any]: ライセンス情報
    """
    mock_data = generate_mock_data()
    for license in mock_data["licenses"]:
        yield license

@dlt.resource
def modules_resource() -> Iterator[Dict[str, Any]]:
    """
    SAPのモジュール情報を取得するリソース
    
    Yields:
        Dict[str, Any]: モジュール情報
    """
    mock_data = generate_mock_data()
    for module in mock_data["modules"]:
        yield module

@dlt.resource
def usage_metrics_resource() -> Dict[str, Any]:
    """
    SAPの使用状況メトリクスを取得するリソース
    
    Returns:
        Dict[str, Any]: 使用状況メトリクス
    """
    mock_data = generate_mock_data()
    return mock_data["usage_metrics"]

if __name__ == "__main__":
    # パイプラインの実行
    pipeline = dlt.pipeline(
        pipeline_name="sap_data",
        destination="postgres",
        dataset_name="sap"
    )
    
    # データのロード
    load_info = pipeline.run(sap_source())
    print(f"SAPデータのロード結果: {load_info}")
