"""
MS365からデータを収集するパイプライン
"""

import dlt
from typing import Dict, List, Any, Iterator
from .mock_data import generate_mock_data

@dlt.source
def ms365_source(api_key: str = None) -> Dict[str, Any]:
    """
    MS365からデータを収集するソース
    
    Args:
        api_key: MS365 APIキー（モックモードでは不要）
        
    Returns:
        Dict[str, Any]: リソースを含むソース定義
    """
    return {
        "users": users_resource(),
        "licenses": licenses_resource(),
        "services": services_resource(),
        "usage_metrics": usage_metrics_resource()
    }

@dlt.resource
def users_resource() -> Iterator[Dict[str, Any]]:
    """
    MS365のユーザー情報を取得するリソース
    
    Yields:
        Dict[str, Any]: ユーザー情報
    """
    mock_data = generate_mock_data()
    for user in mock_data["users"]:
        yield user

@dlt.resource
def licenses_resource() -> Iterator[Dict[str, Any]]:
    """
    MS365のライセンス情報を取得するリソース
    
    Yields:
        Dict[str, Any]: ライセンス情報
    """
    mock_data = generate_mock_data()
    for license in mock_data["licenses"]:
        yield license

@dlt.resource
def services_resource() -> Iterator[Dict[str, Any]]:
    """
    MS365のサービス情報を取得するリソース
    
    Yields:
        Dict[str, Any]: サービス情報
    """
    mock_data = generate_mock_data()
    for service in mock_data["services"]:
        yield service

@dlt.resource
def usage_metrics_resource() -> Dict[str, Any]:
    """
    MS365の使用状況メトリクスを取得するリソース
    
    Returns:
        Dict[str, Any]: 使用状況メトリクス
    """
    mock_data = generate_mock_data()
    return mock_data["usage_metrics"]

if __name__ == "__main__":
    # パイプラインの実行
    pipeline = dlt.pipeline(
        pipeline_name="ms365_data",
        destination="postgres",
        dataset_name="ms365"
    )
    
    # データのロード
    load_info = pipeline.run(ms365_source())
    print(f"MS365データのロード結果: {load_info}")
