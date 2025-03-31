from app.connection_db import supabase
from fastapi import APIRouter, Depends
from pydantic import BaseModel
from typing import Optional

class Client(BaseModel):
    id_cliente: Optional[int] = None
    nome: str
    cnpj: str
    telefone: str
    endereco: str

class ClientCreate(BaseModel):
    nome: str
    cnpj: str
    telefone: str
    endereco: str

router = APIRouter()

@router.post('/client/post')
def insert_client(client: ClientCreate):
    data = supabase.table("clientes").insert(
        client.model_dump(exclude_none=True)
    ).execute()
    return {"Cliente inserido": data}

@router.get('/client/get')
def get_client():
    data = supabase.table("clientes").select("*").execute()
    return {"Clientes": data}

@router.put('/client/put/{id_cliente}')
def update_client(id: int, update: ClientCreate):
    data = supabase.table("clientes").update(
        update.model_dump(exclude_none=True)
    ).eq("id_cliente", id).execute()
    return {"Cliente atualizado": data}

@router.delete('/client/delete/{id_cliente}')
def delete_client(id: int):
    data = supabase.table("clientes").delete().eq("id_cliente", id).execute()
    return {"Cliente deletado": data}
