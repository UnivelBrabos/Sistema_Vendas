from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class Vendas(BaseModel):
    id_venda: Optional[int] = None
    id_vendedor: int
    id_cliente: int
    data_venda: datetime
    total: float
    desconto: int

class VendasCreate(BaseModel):
    id_vendedor: int
    id_cliente: int
    data_venda: datetime = Field(default_factory=datetime.now)
    total: float
    desconto: int
