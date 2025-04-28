"""
独自開発CRMシステムのモックデータを生成するモジュール
"""

def generate_mock_data():
    """
    独自開発CRMシステムのモックデータを生成する関数
    
    Returns:
        dict: CRMシステムのモックデータ
    """
    return {
        "users": [
            {
                "id": "CRM001",
                "username": "user1@abc-trading.com",
                "department": "sales",
                "role": "Sales Manager",
                "created_date": "2024-01-01",
                "last_login_date": "2025-04-25",
                "is_active": True
            },
            {
                "id": "CRM002",
                "username": "user2@abc-trading.com",
                "department": "sales",
                "role": "Sales Representative",
                "created_date": "2024-01-15",
                "last_login_date": "2025-04-26",
                "is_active": True
            },
            {
                "id": "CRM003",
                "username": "user3@abc-trading.com",
                "department": "sales",
                "role": "Sales Representative",
                "created_date": "2024-02-01",
                "last_login_date": "2025-04-27",
                "is_active": True
            },
            {
                "id": "CRM004",
                "username": "user4@abc-trading.com",
                "department": "finance",
                "role": "Finance Analyst",
                "created_date": "2024-01-10",
                "last_login_date": "2025-04-20",
                "is_active": True
            },
            {
                "id": "CRM005",
                "username": "user5@abc-trading.com",
                "department": "it",
                "role": "System Administrator",
                "created_date": "2024-01-05",
                "last_login_date": "2025-04-28",
                "is_active": True
            }
        ],
        "modules": [
            {
                "name": "Customer Management",
                "status": "Active",
                "users": ["CRM001", "CRM002", "CRM003"]
            },
            {
                "name": "Sales Pipeline",
                "status": "Active",
                "users": ["CRM001", "CRM002", "CRM003"]
            },
            {
                "name": "Contract Management",
                "status": "Active",
                "users": ["CRM001", "CRM004"]
            },
            {
                "name": "Reporting",
                "status": "Active",
                "users": ["CRM001", "CRM004", "CRM005"]
            },
            {
                "name": "System Administration",
                "status": "Active",
                "users": ["CRM005"]
            }
        ],
        "infrastructure": {
            "servers": [
                {
                    "name": "crm-app-server-01",
                    "type": "Application Server",
                    "cpu_cores": 8,
                    "memory_gb": 32,
                    "storage_gb": 500,
                    "monthly_cost": 50000
                },
                {
                    "name": "crm-db-server-01",
                    "type": "Database Server",
                    "cpu_cores": 16,
                    "memory_gb": 64,
                    "storage_gb": 2000,
                    "monthly_cost": 80000
                }
            ],
            "databases": [
                {
                    "name": "crm-db",
                    "type": "PostgreSQL",
                    "size_gb": 500,
                    "monthly_cost": 20000
                }
            ],
            "maintenance": {
                "monthly_cost": 100000,
                "breakdown": {
                    "internal_staff": 70000,
                    "external_support": 30000
                }
            }
        },
        "usage_metrics": {
            "transactions": {
                "total": 15000,
                "by_department": {
                    "sales": 12000,
                    "finance": 2000,
                    "it": 1000
                },
                "by_module": {
                    "Customer Management": 5000,
                    "Sales Pipeline": 7000,
                    "Contract Management": 2000,
                    "Reporting": 1000
                }
            },
            "storage": {
                "total_gb": 300,
                "by_department": {
                    "sales": 200,
                    "finance": 80,
                    "it": 20
                }
            },
            "api_calls": {
                "total": 5000,
                "by_department": {
                    "sales": 3000,
                    "finance": 1000,
                    "it": 1000
                }
            }
        }
    }

if __name__ == "__main__":
    # テスト用
    import json
    print(json.dumps(generate_mock_data(), indent=2))
