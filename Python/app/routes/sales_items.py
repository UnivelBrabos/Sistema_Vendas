from fastapi import APIRouter, Depends, HTTPException, status
from schemas.itens_vendas import ItensVendaCreate 
from connection_db.database import get_client
from services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

@router.get('/sales_items/get_all')
async def get_sales_items(
    client: httpx.AsyncClient = Depends(get_client)    
):
    response = await get_all(client, "itens_venda")
    return response.json()
    
@router.get('/sales_items/get/{id_itens}')
async def get_sales_items_by_id(
    id_itens: int,
    client: httpx.AsyncClient = Depends(get_client)    
):
    response = await get_by_id(client, "itens_venda", "id_itens", id_itens)
    data = response.json()
    if not data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Venda de Items não encontrado")
    return data[0]

@router.post('/sales_items/post')
async def insert_sales_items(
    itens: ItensVendaCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = itens.model_dump(exclude_none=True)
    response = await insert(client, "itens_venda", data)
    return {"Mensagem": f"{data}"}

@router.put('/sales_items/put/{id_itens}')
async def update_sales_items(
    id_itens: int,
    itens_update: ItensVendaCreate,
    client: httpx.AsyncClient = Depends(get_client)  
):
    data = itens_update.model_dump(exclude_none=True)
    response = await update(client, "itens_venda", "id_itens", id_itens, data)
    return {"Mensagem": f"{data}"}

@router.delete('/sales_items/delete/{id_itens}')
async def delete_sales_items(
    id_itens: int,
    client: httpx.AsyncClient = Depends(get_client)    
):
    response = await delete(client, "itens_venda", "id_itens", id_itens)
    return {"Mensagem": f"id_itens {id_itens} foi deletado"}