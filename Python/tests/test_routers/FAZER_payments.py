import pytest
from httpx import AsyncClient
from asgi_lifespan import LifespanManager
from app.main import app 

pagamento_id_criado = None

@pytest.mark.asyncio
async def test_post():
    global pagamento_id_criado
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            payload = {
                "id_venda": 0,
                "forma_pagamento": "string",
                "status": "string",
                "valor_pago": 0,
                "data_pagamento": "2025-06-16T14:10:09.806Z"
            }
            response = await ac.post("/payments/post", json=payload)
            assert response.status_code == 200
            pagamento_id_criado = response.json()["Mensagem"]
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
    global pagamento_id_criado
    id_pagamento = 1  
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.get(f"/payments/get/{id_pagamento}")
            assert response.status_code == 200
            assert "id_venda" in response.json()


@pytest.mark.asyncio
async def test_put():
    id_pagamento = 8 
    payload = {
        "id_venda": 0,
        "forma_pagamento": "string",
        "status": "string",
        "valor_pago": 0,
        "data_pagamento": "2025-06-16T14:10:09.806Z"
    }
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.put(f"/payments/put/{id_pagamento}", json=payload)
            assert response.status_code == 200


@pytest.mark.asyncio
async def test_delete():
    id_pagamento = 9
    async with LifespanManager(app):
        async with AsyncClient(app=app, base_url="http://test") as ac:
            response = await ac.delete(f"/payments/delete/{id_pagamento}")
            assert response.status_code == 200
