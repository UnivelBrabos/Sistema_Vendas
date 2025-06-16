import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

categoria_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global categoria_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
                "nome_categoria": "Teste",
            }
            response = await ac.post("/category/post", json=payload)
            assert response.status_code == 200
            categoria_id_criado = response.json()["Mensagem"]
            print("POST resposta:", response.json())

@pytest.mark.asyncio
async def test_get_all():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get("/category/get_all")
            assert response.status_code == 200
            assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_get_by_id():
    global categoria_id_criado
    id_categoria = 1  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/category/get/{id_categoria}")
            assert response.status_code == 200
            assert "nome_categoria" in response.json()


@pytest.mark.asyncio
async def test_put():
    id_categoria = 8 
    payload = {
        "nome_categoria": "Teste_update", 
    }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/category/put/{id_categoria}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_categoria = 9
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/category/delete/{id_categoria}")
            assert response.status_code == 200
