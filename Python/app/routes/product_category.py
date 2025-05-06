from connection_db.database import supabase
from schemas.categoria_produto import CategoriasProdutoCreate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/category/post')
async def insert_product_category(category: CategoriasProdutoCreate):
    data = supabase.table("categorias_produto").insert(
        category.model_dump(exclude_none=True)
    ).execute()
    return {"Categoria de Produtos inserido": data}

@router.get('/category/get')
async def get_product_category():
    data = supabase.table("categorias_produto").select("*").execute()
    return {"Categoria de Produtos": data}

@router.put('/category/put/{id_categoria}')
async def update_product_category(id: int, update: CategoriasProdutoCreate):
    data = supabase.table("categorias_produto").insert(
        update.model_dump(exclude_none=True)
    ).eq("id_categoria", id).execute()
    return {"Categoria de Produtos atualizado": data}

@router.delete('/category/delete/{id_categoria}')
async def delete_product_category(id: int):
    data = supabase.table("categorias_produto").delete().eq("id_categoria", id).execute()
    return {"Categoria de Produtos deletado": data}  
  