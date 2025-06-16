from fastapi import APIRouter, Depends, HTTPException, status
from schemas.produtos import ProdutosCreate 
from connection_db.database import get_client
from services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

    
@router.get('/products/get_all')
async def get_product(
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_all(client, "produtos")
    return response.json()
    
@router.get('/products/get/{id_produto}')    
async def get_product_by_id(
    id_produto: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_by_id(client, "produtos", "id_produto", id_produto)   
    product = response.json()
    if not product:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Produto não encontrado")
    return product[0]

@router.post('/products/post')
async def insert_product(
    product: ProdutosCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = product.model_dump(exclude_none=True)
    response = await insert(client, "produtos", data)
    return {"Mensagem": f"{data}"}
    
@router.put('/products/put/{id_produto}')
async def update_product(
    id_produto: int,
    product_update: ProdutosCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = product_update.model_dump(exclude_none=True)
    response = await update(client, "produtos", "id_produto", id_produto, data)
    return {"Mensagem": f"{data}"}        

@router.delete('/products/delete/{id_produto}')
async def delete_product(
    id_produto: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await delete(client, "produtos", "id_produto", id_produto)
    return {"Mensagem": f"id_produto {id_produto} foi deletado"}
  