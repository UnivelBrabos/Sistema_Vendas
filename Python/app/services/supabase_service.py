import httpx

async def insert(client: httpx.AsyncClient, table: str, data: dict):
    response = await client.post(f"/{table}", json=data)
    response.raise_for_status()
    return response

async def get_all(client: httpx.AsyncClient, table: str):
    response = await client.get(f"/{table}")
    response.raise_for_status()
    return response

async def get_by_id(client: httpx.AsyncClient, table: str, id_name: str, id_value):
    response = await client.get(f"/{table}?{id_name}=eq.{id_value}")
    response.raise_for_status()
    return response

async def update(client: httpx.AsyncClient, table: str, id_name: str, id_value, data: dict):
    response = await client.patch(f"/{table}?{id_name}=eq.{id_value}", json=data)
    response.raise_for_status()
    return response

async def delete(client: httpx.AsyncClient, table: str, id_name: str, id_value):
    response = await client.delete(f"/{table}?{id_name}=eq.{id_value}")
    response.raise_for_status()
    return response
