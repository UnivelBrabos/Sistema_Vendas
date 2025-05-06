import uvicorn
from fastapi import FastAPI
from routes import clients, customer_segments, payments, product_category, products, sales_items, sales, sellers, users

app = FastAPI()

app.include_router(clients.router, tags=["Clientes"])
app.include_router(customer_segments.router, tags=["Segmento do Cliente"])
#app.include_router(log.router, tags=["Log"])
app.include_router(payments.router, tags=["Pagamentos"])
app.include_router(product_category.router,tags=["Categoria do Produtos"]) 
app.include_router(products.router, tags=["Produtos"])
app.include_router(sales_items.router, tags=["Venda dos Itens"])
app.include_router(sales.router, tags=["Vendas"])
app.include_router(sellers.router, tags=["Vendedores"])
app.include_router(users.router, tags=["Usuários"])

@app.get("/")
async def root():
    return {"Seguinte, pra vcs verem a documentação é : http://localhost:8000/redoc ou http://localhost:8000/docs"}

if __name__ == "__main__":
    # Modo correto de rodar
    #uvicorn.run(app,host="localhost", port=8000)

    # Modo Dev, é só pra eu poder alterar em tempo real e testar
    uvicorn.run("main:app",host="localhost", port=8000, reload=True)