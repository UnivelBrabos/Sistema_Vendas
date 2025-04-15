from app.connection_db import supabase
from app.schemas.pagamentos import PagamentosCreate
from fastapi import APIRouter

router = APIRouter()

@router.post('/payments/post')
def insert_payments(payments: PagamentosCreate):
    data = supabase.table("pagamentos").insert(
        payments.model_dump(exclude_none=True)
    ).execute()
    return {"Pagamentos inserido": data}

@router.get('/payments/get')
def get_payments():
    data = supabase.table("pagamentos").select("*").execute()
    return {"Pagamentos": data}

@router.put('/payments/put/{id_pagamento}')
def put_payments(id: int, update: PagamentosCreate):
    data = supabase.table("pagamentos").update(
        update.model_dump(exclude_none=True)
    ).eq("id_pagamentos", id)
    return {"Pagamentos atualizados": data}

@router.delete('/payments/delete/{id_pagamento}')
def delete_payments(id: int):
    data = supabase.table("pagamentos").delete().eq("id_pagamento", id).execute()
    return {"Pagamento deletado": data}