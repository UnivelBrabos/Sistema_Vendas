from app.connection_db import supabase
from app.schemas.vendedores import VendedoresCreate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/sellers/post')
def insert_sellers(sellers: VendedoresCreate):
    data = supabase.table("vendedores").insert(
        sellers.model_dump(exclude_none=True)
    ).execute()
    return {"Vendedor inserido": data}

@router.get('/sellers/get')
def get_sellers():
    data = supabase.table("vendedores").select("*").execute()
    return {"vendedor": data}

@router.put('/sellers/put/{id_vendedor}')
def update_sellers(id: int, update: VendedoresCreate):
    data = supabase.table("vendedores").update(
        update.model_dump(exclude_none=True)
        ).eq("id_vendedor", id).execute()
    return {"vendedor": data}

@router.delete('/sellers/delete/{id_vendedor}')
def delete_sellers(id: int):
    data = supabase.table("vendedores").delete().eq("id_vendedor", id).execute()
    return {"message": "Venda deletado", "data": data}


