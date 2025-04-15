from pydantic import BaseModel
from typing import Optional

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