from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class Log(BaseModel):
    id_log: Optional[int] = None
    ocorrencia: str
    tipo_evento: str
    data_hora: datetime
    
class LogsCreate(BaseModel):
    ocorrencia: str
    tipo_evento: str
    data_hora: datetime