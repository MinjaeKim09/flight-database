from config import init_db_pool
print("Starting DB init...")
try:
    init_db_pool()
    print("DB init success")
except Exception as e:
    print(f"DB init failed: {e}")
