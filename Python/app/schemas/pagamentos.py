from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class Pagamento(BaseModel):
    id_pagamentos: Optional[int] = None
    id_venda: int
    forma_pagamento: str
    status: str
    valor_pago:float
    data_pagamento: datetime
    
class PagamentoCreate(BaseModel):
    id_venda: int
    forma_pagamento: str
    status: str
    valor_pago:float
    data_pagamento: datetime