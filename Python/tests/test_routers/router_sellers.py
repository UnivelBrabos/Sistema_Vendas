import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

vendedor_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global vendedor_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
            "nome": "Teste",
            "email": "teste@teste.com",
            "telefone": "99999999999",
            "data_contratacao": "2025-06-15",
            "salario": 1800.00
            }
            response = await ac.post("/sellers/post", json=payload)
            assert response.status_code == 200
            vendedor_id_criado = response.json()["Mensagem"]
            print("POST resposta:", response.json())

@pytest.mark.asyncio
async def test_get_all():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get("/sellers/get_all")
            assert response.status_code == 200
            assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_get_by_id():
    global vendedor_id_criado
    id_vendedor = 13  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/sellers/get/{id_vendedor}")
            assert response.status_code == 200
            assert "nome" in response.json()


@pytest.mark.asyncio
async def test_put():
    id_vendedor = 5
    payload = {
        "nome": "teste_update",
        "email": "teste@update.com",
        "telefone": "99999999999",
        "data_contratacao": "2025-06-15",
        "salario": 1000.20
        }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/sellers/put/{id_vendedor}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_vendedor = 13
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/sellers/delete/{id_vendedor}")
            assert response.status_code == 200
