from fastapi import APIRouter, Depends, HTTPException, status
from schemas.categoria_produto import CategoriasProdutoCreate 
from connection_db.database import get_client
from services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

@router.get('/category/get_all')
async def get_product_category(
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_all(client, "categorias_produto")
    return response.json()

@router.get('/category/get/{id_categoria}')
async def get_category_by_id(
    id_categoria: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_by_id(client, "categorias_produto", "id_categoria", id_categoria)
    category = response.json()
    if not category:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Categoria de produto não encontrado")
    return category[0]

@router.post('/category/post')
async def insert_product_category(
    category: CategoriasProdutoCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = category.model_dump(exclude_none=True)
    response = await insert(client, "categorias_produto", data)
    print(data)
    return {"Mensagem": f"{data}"}

@router.put('/category/put/{id_categoria}')
async def update_product_category(
    id_categoria: int,
    category_update: CategoriasProdutoCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = category_update.model_dump(exclude_none=True)
    response = await update(client, "categorias_produto", "id_categoria", id_categoria, data)
    return {"Mensagem": f"{data}"}

@router.delete('/category/delete/{id_categoria}')
async def delete_product_category(
    id_categoria: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await delete(client, "categorias_produto", "id_categoria", id_categoria)
    return {"Mensagem": f"id_categoria {id_categoria} foi deletado"}