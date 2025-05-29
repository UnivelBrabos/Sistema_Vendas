from pydantic import BaseModel
from typing import Optional

class Clientes(BaseModel):
    id_cliente: Optional[int] = None
    nome: str
    cnpj: str
    telefone: str
    endereco: str
    segmento: int

class ClientesCreate(BaseModel):
    nome: str
    cnpj: str
    telefone: str
    endereco: str
    segmento: int
