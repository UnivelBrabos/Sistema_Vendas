import pytest
from pydantic import ValidationError
from app.schemas.produtos import ProdutosCreate

def test_produtos_valido():
    produto = ProdutosCreate(
        nome="Coca-cola",
        descricao="Refrigerante de cola 2L",
        preco=8.50,
        estoque=10,
        lote=1,
        categoria_produto=2
    )
    assert produto.preco == 8.50
    assert produto.categoria_produto == 2

def test_produtos_invalido():
    with pytest.raises(ValidationError):
        ProdutosCreate(
            nome="Coca-cola",
            descricao="Refrigerante de cola 2L",
            preco="oito e cinqueta",
            estoque=10,
            lote=1,
            categoria_produto=2
        )

def test_produtos_faltando_campo():
    with pytest.raises(ValidationError):
        ProdutosCreate(
            nome="Coca-cola",
            descricao="Refrigerante de cola 2L",
            preco=8.50,
            estoque=10,
            lote=1
        )
