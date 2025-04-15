from app.connection_db import supabase
from app.schemas.clientes import ClientesCreate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/client/post')
def insert_client(client: ClientesCreate):
    data = supabase.table("clientes").insert(
        client.model_dump(exclude_none=True)
    ).execute()
    return {"Cliente inserido": data}

@router.get('/client/get')
def get_client():
    data = supabase.table("clientes").select("*").execute()
    return {"Clientes": data}

@router.put('/client/put/{id_cliente}')
def update_client(id: int, update: ClientesCreate):
    data = supabase.table("clientes").update(
        update.model_dump(exclude_none=True)
    ).eq("id_cliente", id).execute()
    return {"Cliente atualizado": data}

@router.delete('/client/delete/{id_cliente}')
def delete_client(id: int):
    data = supabase.table("clientes").delete().eq("id_cliente", id).execute()
    return {"Cliente deletado": data}
