from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class Usuarios(BaseModel):
    id_usuario: Optional[int] = None
    nome: str
    email: str
    senha_hash: str #Lembro de alguma função para isso
    cargo: str
    criado_em: datetime

class UsuariosCreate(BaseModel):
    nome: str
    email: str
    senha_hash: str
    cargo: str
    criado_em: datetime
