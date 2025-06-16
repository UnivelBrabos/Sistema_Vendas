import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

venda_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global venda_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
                "id_vendedor": 0,
                "id_cliente": 0,
                "data_venda": "2025-06-16T14:38:05.501Z",
                "total": 0,
                "desconto": 0
            }
            response = await ac.post("/payments/post", json=payload)
            assert response.status_code == 200
            venda_id_criado = response.json()["Mensagem"]
            print("POST resposta:", response.json())

@pytest.mark.asyncio
async def test_get_all():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get("/payments/get_all")
            assert response.status_code == 200
            assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_get_by_id():
    global venda_id_criado
    id_venda = 1  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/payments/get/{id_venda}")
            assert response.status_code == 200
            assert "id_vendedor" in response.json()


@pytest.mark.asyncio
async def test_put():
    id_venda = 8 
    payload = {
        "id_vendedor": 0,
        "id_cliente": 0,
        "data_venda": "2025-06-16T14:38:05.501Z",
        "total": 0,
        "desconto": 0
    }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/payments/put/{id_venda}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_venda = 9
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/payments/delete/{id_venda}")
            assert response.status_code == 200
