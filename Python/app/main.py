from fastapi import FastAPI, Request
from app.connection_db.database import lifespan, get_client
from app.services.log_service import log_request 
import httpx

from app.routes import (
    clients, customer_segments, payments,
    product_category, products, sales_items,
    sales, sellers, users, log
)

app = FastAPI(lifespan=lifespan)

@app.middleware("http")
async def log_middleware(request: Request, call_next):
    client: httpx.AsyncClient = get_client()

    response = await call_next(request)

    if not request.url.path.startswith(("/favicon.ico", "/redoc", "/openapi.json" "/docs")):
        try:
            await log_request(
                client=client,
                evento=request.method,
                rota=request.url.path
            )
        except Exception as e:
            print(f"[LOG ERRO] Falha ao logar requisição: {e}")

    return response

app.include_router(log.router, tags=["Logs"])
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