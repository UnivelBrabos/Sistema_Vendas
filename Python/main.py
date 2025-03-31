import uvicorn
from fastapi import FastAPI
from app.routes import client, product, sales, sales_itens, selles

app = FastAPI()

app.include_router(client.router, tags=["Client"])
app.include_router(product.router, tags=["Product"])
app.include_router(sales.router, tags=["Sales"])
app.include_router(selles.router, tags=["Selles"])
app.include_router(sales_itens.router, tags=["SalesItens"])

@app.get("/")
async def root():
    return {"message: default"}

if __name__ == "__main__":
    uvicorn.run(app,host="localhost", port=8000)