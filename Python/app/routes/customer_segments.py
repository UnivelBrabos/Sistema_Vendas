from app.connection_db import supabase
from app.schemas.segmentos_clientes import SegmentosClienteCreate
from fastapi import APIRouter

router = APIRouter()

@router.post('/customer_segments/post')
def insert_customer_segments(segments: SegmentosClienteCreate):
    data = supabase.table("segmentos_cliente").insert(
        segments.model_dump(exclude_none=True)
    ).execute()
    return {"Segmento do Cliente inserido": data}

@router.get('/costumer_segments/get')
def get_customer_segments():
    data = supabase.table("segmentos_cliente").select("*").execute()
    return {"Segmentos de Clientes": data}

@router.put('/customer_segments/put/{id_segmento}')
def update_customer_segments(id: int, update: SegmentosClienteCreate):
    data = supabase.table("segmentos_cliente").update(
        update.model_dump(exclude_none=True)
    ).execute()
    return {"Segmento do Cliente atualizado": data}

@router.delete('/customer_segments/delete/{id_segmento}')
def delete_customer_segments(id: int):
    data = supabase.table("segmentos_cliente").delete().eq("id)segmento", id).execute()
    return {"Segmento do Cliente deletado": data}
