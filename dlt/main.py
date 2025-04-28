"""
すべてのデータソースからデータを収集するメインスクリプト
"""

import dlt
import argparse
from typing import List, Optional

# 各コネクタのソースをインポート
from connectors.salesforce.pipeline import salesforce_source
from connectors.sap.pipeline import sap_source
from connectors.ms365.pipeline import ms365_source
from connectors.crm.pipeline import crm_source

def run_pipeline(sources: List[str] = None):
    """
    指定されたソースのデータ収集パイプラインを実行する
    
    Args:
        sources: 実行するソースのリスト（指定がない場合はすべて実行）
    """
    available_sources = {
        "salesforce": salesforce_source,
        "sap": sap_source,
        "ms365": ms365_source,
        "crm": crm_source
    }
    
    # ソースが指定されていない場合はすべて実行
    if not sources:
        sources = list(available_sources.keys())
    
    # 各ソースのパイプラインを実行
    for source_name in sources:
        if source_name not in available_sources:
            print(f"警告: {source_name} は利用可能なソースではありません。スキップします。")
            continue
        
        print(f"{source_name} からデータを収集しています...")
        
        # パイプラインの設定
        pipeline = dlt.pipeline(
            pipeline_name=f"{source_name}_data",
            destination="postgres",
            dataset_name=source_name
        )
        
        # データのロード
        source_function = available_sources[source_name]
        load_info = pipeline.run(source_function())
        
        print(f"{source_name} データのロード結果: {load_info}")
        print(f"{source_name} からのデータ収集が完了しました。")
    
    print("すべてのデータ収集が完了しました。")

if __name__ == "__main__":
    # コマンドライン引数の解析
    parser = argparse.ArgumentParser(description='データソースからデータを収集します。')
    parser.add_argument('--sources', nargs='+', help='収集するデータソース（salesforce, sap, ms365, crm）')
    
    args = parser.parse_args()
    
    # パイプラインの実行
    run_pipeline(args.sources)
