from fastapi import APIRouter, Depends, HTTPException, status
from schemas.pagamentos import PagamentoCreate
from connection_db.database import get_client
from services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

@router.get('/payments/get_all')
async def get_payments(
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_all(client, "pagamentos")
    return response.json()
    
@router.get('/payments/get/{id_pagamento}')
async def get_by_payments_id(
    id_pagamento: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_by_id(client, "pagamentos", "id_pagamento", id_pagamento)
    payments = response.json()
    if not payments:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Pagamento não encontrado")
    return payments[0]

@router.post('/payments/post')
async def insert_payments(
    payments: PagamentoCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = payments.model_dump(exclude_none=True)
    data["data_pagamento"] = payments.data_pagamento.isoformat()
    response = await insert(client, "pagamentos", data)
    return {"Mensagem": f"{data}"}

@router.put('/payments/put/{id_pagamento}')
async def put_payments(
    id_pagamento: int,
    payments_update: PagamentoCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = payments_update.model_dump(exclude_none=True)
    data["data_pagamento"] = payments_update.data_pagamento.isoformat()
    response = await update(client, "pagamentos", "id_pagamento", id_pagamento, data)
    return {"Mensagem": f"{data}"}

@router.delete('/payments/delete/{id_pagamento}')
async def delete_payments(
    id_pagamento: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await delete(client, "pagamentos", "id_pagamento", id_pagamento)
    return {"Mensagem": f"id_pagamentos {id_pagamento} foi deletado"}