from connection_db.database import supabase
from schemas.produtos import ProdutosCreate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/product/post')
async def insert_product(product: ProdutosCreate):
    data = supabase.table("produtos").insert(
        product.model_dump(exclude_none=True)
    ).execute()
    return {"Produto inserido": data}

@router.get('/product/get')
async def get_product():
    data = supabase.table("produtos").select("*").execute()
    return {"produtos": data}

@router.put('/product/put/{id_produto}')
async def update_product(id: int, update: ProdutosCreate):
    data = supabase.table("produtos").update(
        update.model_dump(exclude_none=True)
        ).eq("id_produto", id).execute()
    return {"Produto atualizado": data}    

@router.delete('/product/delete/{id_produto}')
async def delete_product(id: int):
    data = supabase.table("produtos").delete().eq("id_produto", id).execute()
    return {"Produto deletado": data}
