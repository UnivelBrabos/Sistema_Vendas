from app.connection_db import supabase
from fastapi import APIRouter, Depends
from pydantic import BaseModel
from typing import Optional

class SalesItens(BaseModel):
    id_itens: Optional[int] = None
    id_venda: int
    id_produto: int
    quantidade_lote: int
    subtotal: float

class SalesItensCreate(BaseModel):
    id_itens: Optional[int] = None
    id_venda: int
    id_produto: int
    quantidade_lote: int
    subtotal: float

router = APIRouter()

@router.post('/sales_itens/post')
def insert_ItemSales(salesItens: SalesItensCreate):
    data = supabase.table("itens_venda").insert(
        salesItens.model_dump(exclude_none=True)
    ).execute()
    return {"Venda de itens inserido": data}

@router.get('/sales_itens/get')
def get_ItemSales():
    data = supabase.table("itens_venda").select("*").execute()
    return {"Vendas de itens": data}

@router.put('/sales_itens/put/{id_itens}')
def update_saleItens(id: int, update: SalesItensCreate):
    data = supabase.table("itens_venda").update(
        update.model_dump(exclude_none=True)
    ).eq("id_venda", id).execute()
    return {"Venda de itens atualizado": data}

@router.delete('/sales_itens/delete/{id_itens}')
def delete_ItemSales(id: int):
    data = supabase.table("itens_venda").delete().eq("id_itens", id).execute()
    return {"Venda de itens deletado": data}
