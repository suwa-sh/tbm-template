"""
MS365のモックデータを生成するモジュール
"""

def generate_mock_data():
    """
    MS365のモックデータを生成する関数
    
    Returns:
        dict: MS365のモックデータ
    """
    return {
        "users": [
            {
                "id": "MS001",
                "username": "user1@abc-trading.com",
                "department": "sales",
                "license_type": "Microsoft 365 E3",
                "created_date": "2024-01-01",
                "last_login_date": "2025-04-25",
                "is_active": True
            },
            {
                "id": "MS002",
                "username": "user2@abc-trading.com",
                "department": "sales",
                "license_type": "Microsoft 365 E3",
                "created_date": "2024-01-15",
                "last_login_date": "2025-04-26",
                "is_active": True
            },
            {
                "id": "MS003",
                "username": "user3@abc-trading.com",
                "department": "sales",
                "license_type": "Microsoft 365 E3",
                "created_date": "2024-02-01",
                "last_login_date": "2025-04-27",
                "is_active": True
            },
            {
                "id": "MS004",
                "username": "user4@abc-trading.com",
                "department": "finance",
                "license_type": "Microsoft 365 E3",
                "created_date": "2024-01-10",
                "last_login_date": "2025-04-20",
                "is_active": True
            },
            {
                "id": "MS005",
                "username": "user5@abc-trading.com",
                "department": "it",
                "license_type": "Microsoft 365 E5",
                "created_date": "2024-01-05",
                "last_login_date": "2025-04-28",
                "is_active": True
            }
        ],
        "licenses": [
            {
                "type": "Microsoft 365 E3",
                "count": 4,
                "monthly_cost_per_user": 20.00,
                "total_monthly_cost": 80.00
            },
            {
                "type": "Microsoft 365 E5",
                "count": 1,
                "monthly_cost_per_user": 35.00,
                "total_monthly_cost": 35.00
            }
        ],
        "services": [
            {
                "name": "Exchange Online",
                "status": "Active",
                "users": ["MS001", "MS002", "MS003", "MS004", "MS005"]
            },
            {
                "name": "SharePoint Online",
                "status": "Active",
                "users": ["MS001", "MS002", "MS003", "MS004", "MS005"]
            },
            {
                "name": "Teams",
                "status": "Active",
                "users": ["MS001", "MS002", "MS003", "MS004", "MS005"]
            },
            {
                "name": "OneDrive for Business",
                "status": "Active",
                "users": ["MS001", "MS002", "MS003", "MS004", "MS005"]
            },
            {
                "name": "Power BI",
                "status": "Active",
                "users": ["MS005"]
            }
        ],
        "usage_metrics": {
            "exchange": {
                "total_mailboxes": 5,
                "total_storage_gb": 50,
                "by_department": {
                    "sales": 30,
                    "finance": 15,
                    "it": 5
                }
            },
            "sharepoint": {
                "total_sites": 10,
                "total_storage_gb": 200,
                "by_department": {
                    "sales": 100,
                    "finance": 50,
                    "it": 50
                }
            },
            "teams": {
                "total_teams": 8,
                "total_channels": 25,
                "total_meetings": 120,
                "by_department": {
                    "sales": 60,
                    "finance": 30,
                    "it": 30
                }
            },
            "onedrive": {
                "total_storage_gb": 100,
                "by_department": {
                    "sales": 60,
                    "finance": 30,
                    "it": 10
                }
            }
        }
    }

if __name__ == "__main__":
    # テスト用
    import json
    print(json.dumps(generate_mock_data(), indent=2))
