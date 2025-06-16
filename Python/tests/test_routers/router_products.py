import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

produto_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global produto_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
                "nome": "Teste",
                "descricao": "Descrição Teste",
                "preco": 1,
                "estoque": 1,
                "lote": 1,
                "categoria_produto": 1
            }
            response = await ac.post("/products/post", json=payload)
            assert response.status_code == 200
            produto_id_criado = response.json()["Mensagem"]
            print("POST resposta:", response.json())

@pytest.mark.asyncio
async def test_get_all_clients():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get("/products/get_all")
            assert response.status_code == 200
            assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_get_by_id():
    global produto_id_criado
    id_produto = 21  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/products/get/{id_produto}")
            assert response.status_code == 200
            assert "nome" in response.json()


@pytest.mark.asyncio
async def test_put():
    id_produto = 31 
    payload = {
        "nome": "Teste",
        "descricao": "Descrição Teste",
        "preco": 1,
        "estoque": 1,
        "lote": 1,
        "categoria_produto": 1
    }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/products/put/{id_produto}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_produto = 31
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/products/delete/{id_produto}")
            assert response.status_code == 200
