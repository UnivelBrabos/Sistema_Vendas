import pytest
from pydantic import ValidationError
from app.schemas.clientes import ClientesCreate  

def test_clientes_create_valido():
    cliente = ClientesCreate(
        nome="Empresa Exemplo",
        cnpj="12.345.678/0001-99",
        telefone="11999999999",
        endereco="Rua ABC, 123",
        segmento=1
    )
    assert cliente.nome == "Empresa Exemplo"
    assert cliente.segmento == 1

def test_clientes_create_faltando_nome():
    with pytest.raises(ValidationError):
        ClientesCreate(
            cnpj="12.345.678/0001-99",
            telefone="11999999999",
            endereco="Rua ABC, 123",
            segmento=1
        )

def test_clientes_create_segmento_invalido():
    with pytest.raises(ValidationError):
        ClientesCreate(
            nome="Empresa",
            cnpj="12.345.678/0001-99",
            telefone="11999999999",
            endereco="Rua ABC",
            segmento="errado"  
        )
