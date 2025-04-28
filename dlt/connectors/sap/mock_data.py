"""
SAPのモックデータを生成するモジュール
"""

def generate_mock_data():
    """
    SAPのモックデータを生成する関数
    
    Returns:
        dict: SAPのモックデータ
    """
    return {
        "users": [
            {
                "id": "SAP001",
                "username": "user1@abc-trading.com",
                "department": "finance",
                "role": "Finance Manager",
                "created_date": "2024-01-01",
                "last_login_date": "2025-04-25",
                "is_active": True
            },
            {
                "id": "SAP002",
                "username": "user2@abc-trading.com",
                "department": "finance",
                "role": "Accountant",
                "created_date": "2024-01-15",
                "last_login_date": "2025-04-26",
                "is_active": True
            },
            {
                "id": "SAP003",
                "username": "user3@abc-trading.com",
                "department": "finance",
                "role": "Accountant",
                "created_date": "2024-02-01",
                "last_login_date": "2025-04-27",
                "is_active": True
            },
            {
                "id": "SAP004",
                "username": "user4@abc-trading.com",
                "department": "sales",
                "role": "Sales Analyst",
                "created_date": "2024-01-10",
                "last_login_date": "2025-04-20",
                "is_active": True
            },
            {
                "id": "SAP005",
                "username": "user5@abc-trading.com",
                "department": "it",
                "role": "System Administrator",
                "created_date": "2024-01-05",
                "last_login_date": "2025-04-28",
                "is_active": True
            }
        ],
        "licenses": [
            {
                "type": "SAP ERP Professional",
                "assigned_to": "SAP001",
                "status": "Active",
                "monthly_cost": 250.00
            },
            {
                "type": "SAP ERP Professional",
                "assigned_to": "SAP002",
                "status": "Active",
                "monthly_cost": 250.00
            },
            {
                "type": "SAP ERP Professional",
                "assigned_to": "SAP003",
                "status": "Active",
                "monthly_cost": 250.00
            },
            {
                "type": "SAP ERP Limited",
                "assigned_to": "SAP004",
                "status": "Active",
                "monthly_cost": 150.00
            },
            {
                "type": "SAP ERP Admin",
                "assigned_to": "SAP005",
                "status": "Active",
                "monthly_cost": 350.00
            }
        ],
        "modules": [
            {
                "name": "Financial Accounting",
                "status": "Active",
                "monthly_cost": 5000.00,
                "users": ["SAP001", "SAP002", "SAP003"]
            },
            {
                "name": "Controlling",
                "status": "Active",
                "monthly_cost": 3000.00,
                "users": ["SAP001", "SAP002"]
            },
            {
                "name": "Sales and Distribution",
                "status": "Active",
                "monthly_cost": 4000.00,
                "users": ["SAP004"]
            },
            {
                "name": "Materials Management",
                "status": "Active",
                "monthly_cost": 3500.00,
                "users": ["SAP001", "SAP004"]
            }
        ],
        "usage_metrics": {
            "transactions": {
                "total": 25000,
                "by_department": {
                    "finance": 15000,
                    "sales": 8000,
                    "it": 2000
                },
                "by_module": {
                    "Financial Accounting": 12000,
                    "Controlling": 3000,
                    "Sales and Distribution": 8000,
                    "Materials Management": 2000
                }
            },
            "storage": {
                "total_gb": 500,
                "by_department": {
                    "finance": 300,
                    "sales": 150,
                    "it": 50
                }
            },
            "batch_jobs": {
                "total": 1200,
                "by_department": {
                    "finance": 800,
                    "sales": 300,
                    "it": 100
                }
            }
        }
    }

if __name__ == "__main__":
    # テスト用
    import json
    print(json.dumps(generate_mock_data(), indent=2))
