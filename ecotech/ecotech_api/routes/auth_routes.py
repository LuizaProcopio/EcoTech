from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Usuario, CodigoRecuperacao
from schemas import UsuarioCadastro, UsuarioLogin, EsqueceuSenha, VerificarCodigo, NovaSenha
from auth import criptografar_senha, verificar_senha, criar_token
from email_service import gerar_codigo, enviar_codigo_email
from datetime import datetime, timedelta

router = APIRouter()


# ─── CADASTRO ────────────────────────────────────────────

@router.post("/cadastro")
def cadastro(dados: UsuarioCadastro, db: Session = Depends(get_db)):
    # Verifica se email já existe
    usuario_existente = db.query(Usuario).filter(Usuario.email == dados.email).first()
    if usuario_existente:
        raise HTTPException(status_code=400, detail="Email já cadastrado")

    # Cria o usuário
    novo_usuario = Usuario(
        nome=dados.nome,
        email=dados.email,
        senha=criptografar_senha(dados.senha)
    )
    db.add(novo_usuario)
    db.commit()
    db.refresh(novo_usuario)

    return {"mensagem": "Conta criada com sucesso!"}


# ─── LOGIN ───────────────────────────────────────────────

@router.post("/login")
def login(dados: UsuarioLogin, db: Session = Depends(get_db)):
    # Busca o usuário pelo email
    usuario = db.query(Usuario).filter(Usuario.email == dados.email).first()
    if not usuario:
        raise HTTPException(status_code=401, detail="Email ou senha incorretos")

    # Verifica a senha
    if not verificar_senha(dados.senha, usuario.senha):
        raise HTTPException(status_code=401, detail="Email ou senha incorretos")

    # Gera o token JWT
    token = criar_token({"sub": str(usuario.id)})

    return {
        "token": token,
        "usuario_id": usuario.id,
        "nome": usuario.nome,
        "email": usuario.email,
        "pontos": usuario.pontos
    }


# ─── ESQUECEU SENHA ──────────────────────────────────────

@router.post("/esqueceu-senha")
def esqueceu_senha(dados: EsqueceuSenha, db: Session = Depends(get_db)):
    # Verifica se o email existe
    usuario = db.query(Usuario).filter(Usuario.email == dados.email).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Email não encontrado")

    # Gera o código
    codigo = gerar_codigo()

    # Salva o código no banco
    novo_codigo = CodigoRecuperacao(
        email=dados.email,
        codigo=codigo,
        criado_em=datetime.utcnow()
    )
    db.add(novo_codigo)
    db.commit()

    # Envia o código por email
    enviado = enviar_codigo_email(dados.email, codigo)
    if not enviado:
        raise HTTPException(status_code=500, detail="Erro ao enviar email")

    return {"mensagem": "Código enviado para o seu email!"}


# ─── VERIFICAR CÓDIGO ────────────────────────────────────

@router.post("/verificar-codigo")
def verificar_codigo(dados: VerificarCodigo, db: Session = Depends(get_db)):
    # Busca o código mais recente do email
    registro = db.query(CodigoRecuperacao).filter(
        CodigoRecuperacao.email == dados.email,
        CodigoRecuperacao.codigo == dados.codigo
    ).order_by(CodigoRecuperacao.id.desc()).first()

    if not registro:
        raise HTTPException(status_code=400, detail="Código inválido")

    # Verifica se o código expirou (15 minutos)
    expiracao = registro.criado_em + timedelta(minutes=15)
    if datetime.utcnow() > expiracao:
        raise HTTPException(status_code=400, detail="Código expirado")

    return {"mensagem": "Código válido!"}


# ─── NOVA SENHA ──────────────────────────────────────────

@router.post("/nova-senha")
def nova_senha(dados: NovaSenha, db: Session = Depends(get_db)):
    # Verifica o código novamente
    registro = db.query(CodigoRecuperacao).filter(
        CodigoRecuperacao.email == dados.email,
        CodigoRecuperacao.codigo == dados.codigo
    ).order_by(CodigoRecuperacao.id.desc()).first()

    if not registro:
        raise HTTPException(status_code=400, detail="Código inválido")

    # Atualiza a senha
    usuario = db.query(Usuario).filter(Usuario.email == dados.email).first()
    usuario.senha = criptografar_senha(dados.nova_senha)
    db.commit()

    # Deleta o código usado
    db.delete(registro)
    db.commit()

    return {"mensagem": "Senha alterada com sucesso!"}