from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date

class Vendedores(BaseModel):
    id_vendedor: Optional[int] = None
    nome: str
    email: EmailStr
    telefone: str
    data_contratacao: date
    salario: float

class VendedoresCreate(BaseModel):
    nome: str
    email: EmailStr
    telefone: str
    data_contratacao: date 
    salario: float

class VendedoresUpdate(BaseModel):
    nome: str
    email: EmailStr
    telefone: str
    salario: float