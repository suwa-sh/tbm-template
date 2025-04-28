"""
Salesforceのモックデータを生成するモジュール
"""

def generate_mock_data():
    """
    Salesforceのモックデータを生成する関数
    
    Returns:
        dict: Salesforceのモックデータ
    """
    return {
        "users": [
            {
                "id": "SF001",
                "username": "user1@abc-trading.com",
                "department": "sales",
                "title": "Sales Manager",
                "created_date": "2024-01-01",
                "last_login_date": "2025-04-25",
                "is_active": True
            },
            {
                "id": "SF002",
                "username": "user2@abc-trading.com",
                "department": "sales",
                "title": "Sales Representative",
                "created_date": "2024-01-15",
                "last_login_date": "2025-04-26",
                "is_active": True
            },
            {
                "id": "SF003",
                "username": "user3@abc-trading.com",
                "department": "sales",
                "title": "Sales Representative",
                "created_date": "2024-02-01",
                "last_login_date": "2025-04-27",
                "is_active": True
            },
            {
                "id": "SF004",
                "username": "user4@abc-trading.com",
                "department": "finance",
                "title": "Finance Analyst",
                "created_date": "2024-01-10",
                "last_login_date": "2025-04-20",
                "is_active": True
            },
            {
                "id": "SF005",
                "username": "user5@abc-trading.com",
                "department": "it",
                "title": "System Administrator",
                "created_date": "2024-01-05",
                "last_login_date": "2025-04-28",
                "is_active": True
            }
        ],
        "licenses": [
            {
                "type": "Salesforce Sales Cloud",
                "assigned_to": "SF001",
                "status": "Active",
                "monthly_cost": 150.00
            },
            {
                "type": "Salesforce Sales Cloud",
                "assigned_to": "SF002",
                "status": "Active",
                "monthly_cost": 150.00
            },
            {
                "type": "Salesforce Sales Cloud",
                "assigned_to": "SF003",
                "status": "Active",
                "monthly_cost": 150.00
            },
            {
                "type": "Salesforce Sales Cloud",
                "assigned_to": "SF004",
                "status": "Active",
                "monthly_cost": 150.00
            },
            {
                "type": "Salesforce Sales Cloud Admin",
                "assigned_to": "SF005",
                "status": "Active",
                "monthly_cost": 250.00
            }
        ],
        "usage_metrics": {
            "api_calls": {
                "total": 15000,
                "by_department": {
                    "sales": 10000,
                    "finance": 2000,
                    "it": 3000
                }
            },
            "storage": {
                "total_gb": 25,
                "by_department": {
                    "sales": 15,
                    "finance": 5,
                    "it": 5
                }
            },
            "logins": {
                "total": 450,
                "by_department": {
                    "sales": 300,
                    "finance": 50,
                    "it": 100
                }
            }
        }
    }

if __name__ == "__main__":
    # テスト用
    import json
    print(json.dumps(generate_mock_data(), indent=2))
