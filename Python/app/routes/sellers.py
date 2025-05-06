from connection_db.database import supabase
from schemas.vendedores import VendedoresCreate, VendedoresUpdate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/sellers/post')
async def insert_sellers(sellers: VendedoresCreate):
    serielized_data = sellers.model_dump(exclude_none=True)
    serielized_data["data_contratacao"] = sellers.data_contratacao.isoformat()
    
    data = supabase.table("vendedores").insert(
        serielized_data
    ).execute()
    return {"Vendedor inserido": data}

@router.get('/sellers/get')
async def get_sellers():
    data = supabase.table("vendedores").select("*").execute()
    return {"Vendedores": data}

@router.put('/sellers/put/{id_vendedor}')
async def update_sellers(id: int, update: VendedoresUpdate):
    data = supabase.table("vendedores").update(
        update.model_dump(exclude_none=True)
        ).eq("id_vendedor", id).execute()
    return {"Vendedor deletado": data}

@router.delete('/sellers/delete/{id_vendedor}')
async def delete_sellers(id: int):
    data = supabase.table("vendedores").delete().eq("id_vendedor", id).execute()
    return {"Vendedor deletado": data}


