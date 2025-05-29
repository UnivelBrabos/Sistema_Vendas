from fastapi import FastAPI, Request

from routes import (
    clients, customer_segments, 
    payments, product_category,
    products, sales_items,
    sales, sellers, users
    
)

from connection_db.database import lifespan, get_client
from services.log_service import log_request
import httpx

app = FastAPI(lifespan=lifespan)
"""
--------- Log em desenvolvimento ----------
@app.middleware("http")
async def log_middleware(request: Request, call_next):
    client: httpx.AsyncClient = get_client()

    response = await call_next(request)

    if not request.url.path.startswith(("/docs", "/redoc", "/openapi.json", "/favicon.ico")):
        await log_request(
            client=client,
            metodo=request.method,
            rota=request.url.path
        )

    return response
"""

app.include_router(clients.router, tags=["Clientes"])
app.include_router(customer_segments.router, tags=["Segmento do Cliente"])
app.include_router(payments.router, tags=["Pagamentos"])
app.include_router(product_category.router, tags=["Categoria do Produtos"]) 
app.include_router(products.router, tags=["Produtos"])
app.include_router(sales_items.router, tags=["Venda dos Itens"])
app.include_router(sales.router, tags=["Vendas"])
app.include_router(sellers.router, tags=["Vendedores"])
app.include_router(users.router, tags=["Usuários"])

@app.get("/")
async def root():
    return {
        "docs": "http://localhost:8000/docs",
        "redoc": "http://localhost:8000/redoc"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="localhost", port=8000, reload=True)