from app.connection_db import supabase
from fastapi import APIRouter, Depends
from pydantic import BaseModel, EmailStr
from datetime import date
from typing import Optional

class Selles(BaseModel):
    id_vendedor: Optional[int] = None
    nome: str
    email: EmailStr
    telefone: str
    data_contratacao: date
    salario: float

class SellesCreate(BaseModel):
    nome: str
    email: EmailStr
    telefone: str
    data_contratacao: date
    salario: float

router = APIRouter()

@router.post('/selles/post')
def insert_selles(selles: SellesCreate):
    data = supabase.table("vendedores").insert(
        selles.model_dump(exclude_none=True)
    ).execute()
    return {"Vendedor inserido": data}

@router.get('/selles/get')
def get_selles():
    data = supabase.table("vendedores").select("*").execute()
    return {"vendedor": data}

@router.put('/selles/put/{id_vendedor}')
def update_selles(id: int, update: SellesCreate):
    data = supabase.table("vendedores").update(
        update.model_dump(exclude_none=True)
        ).eq("id_vendedor", id).execute()
    return {"vendedor": data}

@router.delete('/selles/delete/{id_vendedor}')
def delete_selles(id: int):
    data = supabase.table("vendedores").delete().eq("id_vendedor", id).execute()
    return {"message": "Venda deletado", "data": data}


