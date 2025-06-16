from fastapi import APIRouter, Depends, HTTPException, status
from app.schemas.segmentos_clientes import SegmentosClienteCreate
from app.connection_db.database import get_client
from app.services.supabase_service import insert, get_all, get_by_id, update, delete
import httpx

router = APIRouter()

@router.get('/customer_segments/get_all')
async def get_customer_segments(
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_all(client, "segmentos_cliente")
    return response.json()

@router.get('/customer_segments/get/{id_segmento}')
async def get_segments_by_id(
    id_segmento: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await get_by_id(client, "segmentos_cliente", "id_segmento", id_segmento)
    segments = response.json()
    if not segments:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Segmento do Cliente não encontrado")
    return segments[0]
    
@router.post('/customer_segments/post')
async def insert_customer_segments(
    segments: SegmentosClienteCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = segments.model_dump(exclude_none=True)
    response = await insert(client, "segmentos_cliente", data)
    return {"Mensagem": f"{data}"}

@router.put('/customer_segments/put/{id_segmento}')
async def update_customer_segments(
    id_segmento: int,
    segment_update: SegmentosClienteCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = segment_update.model_dump(exclude_none=True)
    response = await update(client, "segmentos_cliente", "id_segmento", id_segmento, data)
    return {"Mensagem": f"{data}"}

@router.delete('/customer_segments/delete/{id_segmento}')
async def delete_customer_segments(
    id_segmento: int,
    client: httpx.AsyncClient = Depends(get_client)
):
    response = await delete(client, "segmentos_cliente", "id_segmento", id_segmento)
    return {"Mensagem": f"id_segmento {id_segmento} foi deletado"}
