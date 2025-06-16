import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

items_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global items_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
                "id_venda": 124,
                "id_produto": 27,
                "quantidade_lote": 23,
                "subtotal": 315.23
            }
            response = await ac.post("/sales_items/post", json=payload)
            assert response.status_code == 200
            items_id_criado = response.json()["Mensagem"]
            print("POST resposta:", response.json())

@pytest.mark.asyncio
async def test_get_all():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get("/sales_items/get_all")
            assert response.status_code == 200
            assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_get_by_id():
    global items_id_criado
    id_itens = 21  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/sales_items/get/{id_itens}")
            assert response.status_code == 200
            assert "id_venda" in response.json()


@pytest.mark.asyncio
async def test_put():
    id_itens = 32 
    payload = {
        "id_venda": 124,
        "id_produto": 27,
        "quantidade_lote": 23,
        "subtotal": 315.23
    }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/sales_items/put/{id_itens}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_itens = 31
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/sales_items/delete/{id_itens}")
            assert response.status_code == 200
