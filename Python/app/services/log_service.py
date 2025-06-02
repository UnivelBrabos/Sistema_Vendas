import httpx
from schemas.logs import LogsCreate
from datetime import datetime

async def log_request(client: httpx.AsyncClient, rota: str, evento: str):
    log = LogsCreate(
        ocorrencia=f"Requisição feita na rota {rota}",
        tipo_evento=evento,
        data_hora=datetime.isoformat()
    )
    await client.post("/logs", json=log.model_dump())

