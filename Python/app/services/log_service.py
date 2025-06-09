import httpx
from datetime import datetime

async def log_request(client: httpx.AsyncClient, rota: str, evento: str):
    log_data = {
        "ocorrencia": f"Requisição feita na rota {rota}",
        "tipo_evento": evento,
        "horario": datetime.now().isoformat(sep=" ", timespec="seconds")
    }

    response = await client.post("/Log", json=log_data)

    if response.status_code >= 400:
        print(f"[LOG ERRO] Status: {response.status_code}, Retorno: {response.text}")

