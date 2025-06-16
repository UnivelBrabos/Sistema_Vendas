import pytest
from pydantic import ValidationError, EmailStr
from datetime import datetime, timezone
from app.schemas.usuarios import UsuariosCreate, UsuariosUpdate

def test_usuarios_create_valido():
    horario = datetime.now(timezone.utc)
    usuario = UsuariosCreate(
        nome="Teste",
        email="teste@gmail.com",
        senha_hash="1234",
        cargo="Vendedor",
        criado_em=horario
    )
    assert usuario.email == "teste@gmail.com"
    assert usuario.criado_em == horario

def test_usuarios_create_email_invalido():
    horario = datetime.now(timezone.utc)
    with pytest.raises(ValidationError):
        UsuariosCreate(
            nome="Teste",
            email="testeO_MELHOR_ARROBAgmail.com",
            senha_hash="1234",
            cargo="user",
            criado_em=horario
        )

def test_usuarios_create_faltando_campo():
    horario = datetime.now(timezone.utc)
    with pytest.raises(ValidationError):
        UsuariosCreate(
            nome="Teste",
            email="teste@gmail.com",
            cargo="user",
            criado_em=horario
        )

#  -------------> Teste do update <-------------

def test_usuarios_update_valido():
    usuario = UsuariosUpdate(
        nome="Teste",
        email="teste@gmail.com",
        senha_hash="1234",
        cargo="Vendedor"
    )
    assert usuario.nome == "Teste"
    assert usuario.cargo == "Vendedor"

def test_usuarios_update_invalido():
    with pytest.raises(ValidationError):
        UsuariosUpdate(
            email="testeO_MELHOR_ARROBAgmail.com",
            senha_hash="1234",
            cargo="Vendedor"
        )

def test_usuarios_update_faltando_campo():
    with pytest.raises(ValidationError):
        UsuariosUpdate(
            email="teste@gmail.com",
            senha_hash="1234",
            cargo="Vendedor"
        )
