from fastapi import APIRouter, Depends
from schemas.logs import LogsCreate
from connection_db.database import get_client
from services.supabase_service import insert
import httpx

router = APIRouter()

@router.post("/logs")
async def create_log(
    log: LogsCreate,
    client: httpx.AsyncClient = Depends(get_client)
):
    data = log.model_dump(mode="json")
    response = await insert(client, "Log", data)
    return {"data": response.json()}
