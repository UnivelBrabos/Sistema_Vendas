from pydantic import BaseModel
from typing import Optional

class CategoriasProduto(BaseModel):
    id_categoria: Optional[int] = None
    nome_categoria: str

class CategoriasProdutoCreate(BaseModel):
    nome_categoria: str  