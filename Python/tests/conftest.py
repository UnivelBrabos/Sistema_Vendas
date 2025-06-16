import sys
import os

# Adiciona o diretório "Python/" ao sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app

@pytest.fixture
async def async_client():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            yield ac