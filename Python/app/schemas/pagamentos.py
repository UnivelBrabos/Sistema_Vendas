from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class Pagamentos(BaseModel):
  id_pagamentos: Optional[int] = None
  id_venda: int
  forma_pagamento: str
  status: str
  valor_pago: float
  data_pagamento: datetime

class PagamentosCreate(BaseModel):
  id_venda: int
  forma_pagamento: str
  status: str
  valor_pago: float
  data_pagamento: datetime = Field(default_factory=datetime.now)

class PagamentosUpdate(BaseModel):
  id_venda: int
  forma_pagamento: str
  status: str
  valor_pago: float

