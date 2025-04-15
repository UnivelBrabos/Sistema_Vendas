from app.connection_db import supabase
from app.schemas.usuarios import UsuariosCreate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/users/post')
def insert_users(users: UsuariosCreate):
    data = supabase.table("usuarios").insert(
        users.model_dump(exclude_none=True)
    ).execute()
    return {"Usuários inserido": data}

@router.get('/users/get')
def get_users():
    data = supabase.table("usuarios").select("*").execute()
    return {"Usuários": data}

@router.put('/users/put/{id_usuario}')
def update_users(id: int, update: UsuariosCreate):
    data = supabase.table("usuarios").update(
        update.model_dump(exclude_none=True)
    ).eq("id_usuario", id).execute()
    return {"Usuáirios atualizados": data}

@router.delete('/users/delete/{id_usuario}')
def delete_users(id: int):
    data = supabase.table("usuarios").delete().eq("id_usuario", id).execute()
    return {"Usuário deletado": data}
