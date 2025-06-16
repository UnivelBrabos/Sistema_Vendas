from fastapi import APIRouter, Depends, HTTPException, status
from app.schemas.vendas import VendasCreate, VendasUpdate
from app.connection_db.database import get_client
from app.services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

@router.get('/sales/get_all')
async def get_sales(
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_all(client, "vendas")
    return response.json()

@router.get('/sales/get/{id_venda}')
async def get_sale_by_id(
    id_venda: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_by_id(client, "vendas", "id_venda", id_venda)
    sales = response.json()
    if not sales:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Venda não encontrado")
    return sales[0]        

@router.post('/sales/post')
async def insert_sale(
    sale: VendasCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = sale.model_dump(exclude_none=True)
    data["data_venda"] = sale.data_venda.isoformat()
    response = await insert(client, "vendas", data)
    return {"Mensagem": f"{data}"}

@router.put('/sales/put/{id_venda}')
async def update_sale(
    id_venda: int,
    sale_update: VendasUpdate,
    client: httpx.AsyncClient = Depends(get_client)    
):
    data = sale_update.model_dump(exclude_none=True)
    response = await update(client, "vendas", "id_venda", id_venda, data)
    return {"Mensagem": f"{data}"}

@router.delete('/sales/delete/{id_venda}')
async def delete_sale(
    id_venda: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await delete(client, "vendas", "id_venda", id_venda)
    return {"Mensagem": f"id_venda {id_venda} foi deletado"}