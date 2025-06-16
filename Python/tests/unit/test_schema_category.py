import pytest
from pydantic import ValidationError
from app.schemas.categoria_produto import CategoriasProdutoCreate

def test_categorias_valido():
    categoria = CategoriasProdutoCreate(
        nome_categoria="Roupa"
    )
    assert categoria.nome_categoria == "Roupa"

def test_categorias_invalido():
    with pytest.raises(ValidationError):
        CategoriasProdutoCreate(
            nome_categoria=1,
        )

