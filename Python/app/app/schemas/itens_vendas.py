from pydantic import BaseModel
from typing import Optional

class ItensVenda(BaseModel):
    id_itens: Optional[int] = None
    id_venda: int
    id_produto: int
    quantidade_lote: int
    subtotal: float

class ItensVendaCreate(BaseModel):
    id_venda: int
    id_produto: int
    quantidade_lote: int
    subtotal: float
