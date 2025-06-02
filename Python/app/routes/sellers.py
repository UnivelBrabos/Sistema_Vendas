from fastapi import APIRouter, Depends, HTTPException, status
from schemas.vendedores import VendedoresCreate, VendedoresUpdate
from connection_db.database import get_client
from services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

@router.get('/sellers/get_all')
async def get_sellers(
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_all(client, "vendedores")
    return response.json()

@router.get('/sellers/get/{id_vendedor}')
async def get_seller_by_id(
    id_vendedor: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_by_id(client, "vendedores", "id_vendedor", id_vendedor)
    sellers = response.json()
    if not sellers:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Vendedor não encontrado")
    return sellers[0]

@router.post('/sellers/post')
async def insert_seller(
    seller: VendedoresCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = seller.model_dump(exclude_none=True)
    data["data_contratacao"] = seller.data_contratacao.isoformat()
    response = await insert(client, "vendedores", data)
    return {"Mensagem": f"{data}"}

@router.put('/sellers/put/{id_vendedor}')
async def update_seller(
    id_vendedor: int,
    seller_update: VendedoresUpdate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = seller_update.model_dump(exclude_none=True)
    response = await update(client, "vendedores", "id_vendedor", id_vendedor, data)
    return {"Messagem": f"id_vendedor {id_vendedor} foi deletado"}

@router.delete('/sellers/delete/{id_vendedor}')
async def delete_seller(
    id_vendedor: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await update(client, "vendedores", "id_vendedor", id_vendedor)
    return {"Mensagem": f"id_vendedor {id_vendedor} foi deletado"}
