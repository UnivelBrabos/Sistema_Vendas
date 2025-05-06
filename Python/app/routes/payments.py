from connection_db.database import supabase
from schemas.pagamentos import PagamentosCreate, PagamentosUpdate
from fastapi import APIRouter

router = APIRouter()

@router.post('/payments/post')
async def insert_payments(payments: PagamentosCreate):
    serielized_data = payments.model_dump(exclude_none=True)
    serielized_data["data_pagamento"] = payments.data_pagamento.isoformat()

    data = supabase.table("pagamentos").insert(
        serielized_data
    ).execute()
    return {"Pagamentos inserido": data}

@router.get('/payments/get')
async def get_payments():
    data = supabase.table("pagamentos").select("*").execute()
    return {"Pagamentos": data}

@router.put('/payments/put/{id_pagamento}')
async def put_payments(id: int, update: PagamentosUpdate):
    data = supabase.table("pagamentos").update(
        update.model_dump(exclude_none=True)
    ).eq("id_pagamentos", id)
    return {"Pagamentos atualizados": data}

@router.delete('/payments/delete/{id_pagamento}')
async def delete_payments(id: int):
    data = supabase.table("pagamentos").delete().eq("id_pagamento", id).execute()
    return {"Pagamento deletado": data}