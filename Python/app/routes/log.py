from app.connection_db import supabase
from fastapi import APIRouter, Depends
from pydantic import BaseModel
from datetime import datetime

class Log(BaseModel):
    ocorrencia: str
    tipo_evento: str
    descricao: str
    alteracao: str
    data_hora: datetime

router = APIRouter()

@router.post('/')
def insert_log(log: Log):
    data = supabase.table("Log").insert(
        log.model_dump()
    ).execute()
    return {"Log inserido": data}

@router.get('/')
def get_log():
    data = supabase.table("Log").select("*").execute()
    return {"Logs": data}

@router.delete('/{id}')
def delete_log(id: int):
    data = supabase.table("Log").delete().eq("id", id).execute()
    return {"Log deletado": data}
