import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

url = os.getenv("SUPABASE_URL_TEST")
key = os.getenv("SUPABASE_KEY_TEST")

supabase = create_client(url, key)

