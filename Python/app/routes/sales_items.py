from connection_db.database import supabase
from schemas.itens_vendas import ItensVendaCreate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/sales_items/post')
async def insert_sales_items(salesItens: ItensVendaCreate):
    data = supabase.table("itens_venda").insert(
        salesItens.model_dump(exclude_none=True)
    ).execute()
    return {"Venda de itens inserido": data}

@router.get('/sales_items/get')
async def get_sales_items():
    data = supabase.table("itens_venda").select("*").execute()
    return {"Vendas de itens": data}

@router.put('/sales_items/put/{id_itens}')
async def update_sales_items(id: int, update: ItensVendaCreate):
    data = supabase.table("itens_venda").update(
        update.model_dump(exclude_none=True)
    ).eq("id_venda", id).execute()
    return {"Venda de itens atualizado": data}

@router.delete('/sales_items/delete/{id_itens}')
async def delete_sales_items(id: int):
    data = supabase.table("itens_venda").delete().eq("id_itens", id).execute()
    return {"Venda de itens deletado": data}
