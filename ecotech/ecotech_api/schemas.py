from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

# ─── AUTENTICAÇÃO ───────────────────────────────────────

class UsuarioCadastro(BaseModel):
    nome: str
    email: EmailStr
    senha: str

class UsuarioLogin(BaseModel):
    email: EmailStr
    senha: str

class EsqueceuSenha(BaseModel):
    email: EmailStr

class VerificarCodigo(BaseModel):
    email: EmailStr
    codigo: str

class NovaSenha(BaseModel):
    email: EmailStr
    codigo: str
    nova_senha: str

# ─── PERFIL ─────────────────────────────────────────────

class UsuarioResposta(BaseModel):
    id: int
    nome: str
    email: str
    pontos: int
    criado_em: datetime

    class Config:
        from_attributes = True

class AlterarSenha(BaseModel):
    senha_atual: str
    nova_senha: str

# ─── DESCARTE ────────────────────────────────────────────

class DescarteResposta(BaseModel):
    tipo_lixo: str
    material: str
    motivo_descarte: str
    tempo_degradacao: str
    consequencia_incorreto: str
    pontos_ganhos: int

# ─── CUPONS ──────────────────────────────────────────────

class CupomResposta(BaseModel):
    id: int
    codigo: str
    desconto: float
    validade: datetime
    descricao: str

    class Config:
        from_attributes = True

# ─── RANKING ─────────────────────────────────────────────

class RankingResposta(BaseModel):
    posicao: int
    nome: str
    pontos: int

# ─── SUPORTE ─────────────────────────────────────────────

class SuporteMensagem(BaseModel):
    usuario_id: int
    mensagem: str