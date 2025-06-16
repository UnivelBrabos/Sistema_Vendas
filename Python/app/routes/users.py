from fastapi import APIRouter, Depends, HTTPException, status
from schemas.usuarios import UsuariosCreate, UsuariosUpdate
from connection_db.database import get_client
from services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

@router.get('/users/get_all')
async def get_users(
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_all(client, "usuarios")
    return response.json()

@router.get('/users/get/{id_usuario}')
async def get_user_by_id(
    id_usuario: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_by_id(client, "usuarios", "id_usuario", id_usuario)
    users = response.json()
    if not users:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuário não encontrado")
    return users[0]

@router.post('/users/post')
async def insert_user(
    user: UsuariosCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = user.model_dump(exclude_none=True)
    data["criado_em"] = user.criado_em.isoformat()
    response = await insert(client, "usuarios", data)
    return {"Mensagem": f"{data}"}

@router.put('/users/put/{id_usuario}')
async def update_user(
    id_usuario: int,
    user_update: UsuariosUpdate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = user_update.model_dump(exclude_none=True)
    response = await update(client, "usuarios", "id_usuario", id_usuario, data)
    return {"Mensagem": f"{data}"}

@router.delete('/users/delete/{id_usuario}')
async def delete_user(
    id_usuario: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await delete(client, "usuarios", "id_usuario", id_usuario)
    return {"Mensagem": f"id_usuario {id_usuario} foi deletado"}
