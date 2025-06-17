import os
import httpx
from fastapi import FastAPI
from typing import AsyncGenerator
from contextlib import asynccontextmanager
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

async_client: httpx.AsyncClient | None = None

@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator:
    global async_client
    async_client = httpx.AsyncClient(
        base_url=f"{SUPABASE_URL}/rest/v1",
        headers={
            "apikey": SUPABASE_KEY,
            "Authorization": f"Bearer {SUPABASE_KEY}",
            "Content-Type": "application/json"
        }
    )
    yield
    await async_client.aclose()

def get_client() -> httpx.AsyncClient:
    if async_client is None:
        raise RuntimeError("deu erro")
    return async_client
