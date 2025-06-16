from pydantic import BaseModel
from typing import Optional

class Produtos(BaseModel):
    id_produto: Optional[int] = None
    nome: str
    descricao: str
    preco: float
    estoque: int
    lote: int
    categoria_produto: int

class ProdutosCreate(BaseModel):
    nome: str
    descricao: str
    preco: float
    estoque: int
    lote: int
    categoria_produto: int
