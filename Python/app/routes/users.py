from connection_db.database import supabase
from schemas.usuarios import UsuariosCreate, UsuariosUpdate
from fastapi import APIRouter, Depends

router = APIRouter()

@router.post('/users/post')
async def insert_users(users: UsuariosCreate):
    serielized_data = users.model_dump(exclude_none=True)
    serielized_data['criado_em'] = users.criado_em.isoformat() 

    data = supabase.table("usuarios").insert(
        serielized_data
    ).execute()
    return {"Usuários inserido": data}

@router.get('/users/get')
async def get_users():
    data = supabase.table("usuarios").select("*").execute()
    return {"Usuários": data}

@router.put('/users/put/{id_usuario}')
async def update_users(id: int, update: UsuariosUpdate):
    data = supabase.table("usuarios").update(
        update.model_dump(exclude_none=True)
    ).eq("id_usuario", id).execute()
    return {"Usuáirios atualizados": data}

@router.delete('/users/delete/{id_usuario}')
async def delete_users(id: int):
    data = supabase.table("usuarios").delete().eq("id_usuario", id).execute()
    return {"Usuário deletado": data}
