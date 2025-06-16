import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

segmento_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global segmento_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
                "nome_segmento": "Teste",
            }
            response = await ac.post("/customer_segments/post", json=payload)
            assert response.status_code == 200
            segmento_id_criado = response.json()["Mensagem"]
            print("POST resposta:", response.json())

@pytest.mark.asyncio
async def test_get_all():
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get("/customer_segments/get_all")
            assert response.status_code == 200
            assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_get_by_id():
    global segmento_id_criado
    id_segmento = 1  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/customer_segments/get/{id_segmento}")
            assert response.status_code == 200
            assert "nome_segmento" in response.json()


@pytest.mark.asyncio
async def test_put():
    id_segmento = 8 
    payload = {
        "nome_segmento": "Teste_update",
    }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/customer_segments/put/{id_segmento}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_segmento = 9
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/customer_segments/delete/{id_segmento}")
            assert response.status_code == 200
