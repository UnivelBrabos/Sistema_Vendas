import pytest
from pydantic import ValidationError
from app.schemas.clientes import ClientesCreate  

def test_cliente_valido():
    cliente = ClientesCreate(
        nome="Empresa de Teste",
        cnpj="12.345.678/0001-99",
        telefone="99999999999",
        endereco="Rua ABC, 123",
        segmento=1
    )
    assert cliente.nome == "Empresa de Teste"
    assert cliente.segmento == 1

def test_cliente_invalido():
    with pytest.raises(ValidationError):
        ClientesCreate(
            nome="Empresa",
            cnpj="12.345.678/0001-99",
            telefone="99999999999",
            endereco="Rua ABC, 123",
            segmento="numero um"  
        )

def test_cliente_faltando_campo():
    with pytest.raises(ValidationError):
        ClientesCreate(
            cnpj="12.345.678/0001-99",
            telefone="99999999999",
            endereco="Rua ABC, 123",
            segmento=1
        )