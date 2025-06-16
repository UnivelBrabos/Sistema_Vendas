import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

cliente_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global cliente_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
                "nome": "Teste",
                "cnpj": "15.555.322/0002-04",
                "telefone": "11955555556",
                "endereco": "Rua A, 102",
                "segmento": 2,
            }
            response = await ac.post("/clients/post", json=payload)
            assert response.status_code == 200
            cliente_id_criado = response.json()["Mensagem"]
            print("POST resposta:", response.json())

@pytest.mark.asyncio
async def test_get_all():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get("/clients/get_all")
            assert response.status_code == 200
            assert isinstance(response.json(), list)


@pytest.mark.asyncio
async def test_get_by_id():
    global cliente_id_criado
    id_cliente = 9  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/clients/get/{id_cliente}")
            assert response.status_code == 200
            assert "nome" in response.json()


@pytest.mark.asyncio
async def test_put_cliente():
    id_cliente = 1 
    payload = {
        "nome": "Teste",
        "cnpj": "15.555.322/0002-04",
        "telefone": "11955555556",
        "endereco": "Rua A, 102",
        "segmento": 2,
    }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/clients/put/{id_cliente}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_cliente = 30  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/clients/delete/{id_cliente}")
            assert response.status_code == 200
