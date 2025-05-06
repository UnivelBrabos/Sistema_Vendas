from pydantic import BaseModel
from typing import Optional, datetime

class Logs(BaseModel):
  id_log: Optional[int] = None
  ocorrencia: str
  tipo_evento: str
  descricao: str
  #data_hora: datetime  ------ Acho muito válido ele existir

class LogsCreate(BaseModel):
  ocorrencia: str
  tipo_evento: str
  descricao: str

class LogsCreate(BaseModel):
    ocorrencia: str
    tipo_evento: str
    descricao: str
    tipo_rota: str  # Exemplo: "POST", "GET", "PUT", "DELETE"
    data_hora: Optional[datetime] = datetime.now()