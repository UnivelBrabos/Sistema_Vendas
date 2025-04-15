from app.connection_db import supabase
from app.schemas.logs import LogsCreate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/')
def insert_log(log: LogsCreate):
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
