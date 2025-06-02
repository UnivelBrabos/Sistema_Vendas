from pydantic import BaseModel
from typing import Optional

class SegmentosCliente(BaseModel):
    id_segmento: Optional[int] = None
    nome_segmento: str

class SegmentosClienteCreate(BaseModel):
    nome_segmento: str
