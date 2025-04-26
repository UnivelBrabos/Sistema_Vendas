from pydantic import BaseModel, EmailStr, Field
from typing import Optional

from datetime import datetime

class Usuarios(BaseModel):
    id_usuario: Optional[int] = None
    nome: str
    email: EmailStr
    senha_hash: str 
    cargo: str
    criado_em: datetime

class UsuariosCreate(BaseModel):
    nome: str
    email: EmailStr
    senha_hash: str
    cargo: str
    criado_em: datetime

class UsuariosUpdate(BaseModel):
    nome: str
    email: EmailStr
    senha_hash: str
    cargo: str

class UsuariosGet(BaseModel):
    nome: str
    email: EmailStr
    cargo: str