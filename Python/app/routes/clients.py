from fastapi import APIRouter, Depends, HTTPException, status
from app.schemas.clientes import ClientesCreate
from app.connection_db.database import get_client
from app.services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

@router.get('/clients/get_all')
async def get_clients(
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_all(client, "clientes")
    return response.json()

@router.get('/clients/get/{id_cliente}')
async def get_clients_by_id(
    id_cliente: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_by_id(client, "clientes", "id_cliente", id_cliente)
    clients = response.json()
    if not clients:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cliente não encontrado")
    return clients[0]
    
@router.post('/clients/post')
async def get_clients(
    cliente: ClientesCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = cliente.model_dump(exclude_none=True)
    response = await insert(client, "clientes", data)
    return {"Mensagem": f"{data}"}

@router.put('/clients/put/{id_cliente}')
async def update_client(
    id_cliente: int,
    client_update: ClientesCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = client_update.model_dump(exclude_none=True)
    response = await update(client, "clientes", "id_cliente", id_cliente, data)
    return {"Mensagem": f"{data}"}

@router.delete('/clients/delete/{id_cliente}')
async def delete_client(
    id_cliente: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await delete(client, "clientes", "id_cliente", id_cliente)
    return {"Mensagem": f"id_cliente {id_cliente} foi deletado"}
