from app.connection_db import supabase
from fastapi import APIRouter, Depends
from pydantic import BaseModel
from datetime import date
from typing import Optional

class Sales(BaseModel):
    id_venda: Optional[int] = None
    id_vendedor: int
    id_cliente: int
    data_venda: date
    total: float
    desconto: int

class SalesCreate(BaseModel):
    id_venda: Optional[int] = None
    id_vendedor: int
    id_cliente: int
    data_venda: date
    total: float
    desconto: int
    
router = APIRouter()

@router.post('/sales/post')
def insert_sales(sale: SalesCreate):
    data = supabase.table("vendas").insert(
        sale.model_dump(exclude_none=True)
    ).execute()
    return {"Venda inserida": data}

@router.get('/sales/get')
def get_sales():
    data = supabase.table("vendas").select("*").execute()
    return {"Vendas": data}

@router.put('/sales/put/{id_venda}')
def update_sales(id: int, update: SalesCreate):
    data = supabase.table("vendas").update(
        update.model_dump(exclude_none=True)
        ).eq("id_venda", id).execute()
    return {"Venda atualizado": data}

@router.delete('/sales/delete/{id_venda}')
def delete_sales(id: int):
    data = supabase.table("vendas").delete().eq("id_venda", id).execute()
    return {"Venda deletado": data}
    