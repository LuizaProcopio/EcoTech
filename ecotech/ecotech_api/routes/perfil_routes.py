from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Usuario
from schemas import UsuarioResposta, AlterarSenha
from auth import verificar_senha, criptografar_senha

router = APIRouter()


# ─── VER PERFIL ──────────────────────────────────────────

@router.get("/{usuario_id}", response_model=UsuarioResposta)
def ver_perfil(usuario_id: int, db: Session = Depends(get_db)):
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    return usuario


# ─── ALTERAR SENHA ───────────────────────────────────────

@router.put("/{usuario_id}/alterar-senha")
def alterar_senha(usuario_id: int, dados: AlterarSenha, db: Session = Depends(get_db)):
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    # Verifica se a senha atual está correta
    if not verificar_senha(dados.senha_atual, usuario.senha):
        raise HTTPException(status_code=401, detail="Senha atual incorreta")

    # Atualiza a senha
    usuario.senha = criptografar_senha(dados.nova_senha)
    db.commit()

    return {"mensagem": "Senha alterada com sucesso!"}


# ─── VER PONTOS ──────────────────────────────────────────

@router.get("/{usuario_id}/pontos")
def ver_pontos(usuario_id: int, db: Session = Depends(get_db)):
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    return {
        "usuario_id": usuario.id,
        "nome": usuario.nome,
        "pontos": usuario.pontos
    }