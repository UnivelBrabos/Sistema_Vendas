import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

usuario_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global usuario_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
                "nome": "Teste",
                "email": "teste@gmail.com",
                "senha_hash": "teste",
                "cargo": "Vendedor",
                "criado_em": "2025-06-16T14:13:13.933Z"
            }
            response = await ac.post("/users/post", json=payload)
            assert response.status_code == 200
            usuario_id_criado = response.json()["Mensagem"]
            print("POST resposta:", response.json())

@pytest.mark.asyncio
async def test_get_all():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get("/users/get_all")
            assert response.status_code == 200
            assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_get_by_id():
    global usuario_id_criado
    id_usuario = 2  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/users/get/{id_usuario}")
            assert response.status_code == 200
            assert "nome" in response.json()


@pytest.mark.asyncio
async def test_put():
    id_usuario = 11 
    payload = {
        "nome": "teste",
        "email": "teste@gmail.com",
        "senha_hash": "teste",
        "cargo": "teste",
        "criado_em": "2025-06-16T14:13:13.933Z"
    }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/users/put/{id_usuario}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_usuario = 1
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/users/delete/{id_usuario}")
            assert response.status_code == 200
