from app.connection_db import supabase
from app.schemas.vendas import VendasCreate, Vendas, VendasUpdate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/sales/post')
def insert_sales(sale: VendasCreate):
    serielized_data = sale.model_dump(exclude_none=True)
    serielized_data["data_venda"] = sale.data_venda.isoformat()
    
    data = supabase.table("vendas").insert(
        serielized_data
        ).execute()
    return {"Vendas": data}

@router.get('/sales/get')
def get_sales():
    data = supabase.table("vendas").select("*").execute()
    return {"Vendas": data}

@router.put('/sales/put/{id_venda}')
def update_sales(id: int, update: VendasUpdate):
    data = supabase.table("vendas").update(
        update.model_dump(exclude_none=True)
        ).eq("id_venda", id).execute()
    return {"Venda atualizado": data}

@router.delete('/sales/delete/{id_venda}')
def delete_sales(id: int):
    data = supabase.table("vendas").delete().eq("id_venda", id).execute()
    return {"Venda deletado": data}
    