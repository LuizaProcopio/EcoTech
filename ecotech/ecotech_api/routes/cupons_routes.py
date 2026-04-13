from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Usuario, Cupom, CupomUsuario
from datetime import datetime

router = APIRouter()


# ─── LISTAR CUPONS DISPONÍVEIS ───────────────────────────

@router.get("/")
def listar_cupons(db: Session = Depends(get_db)):
    agora = datetime.utcnow()
    cupons = db.query(Cupom).filter(Cupom.validade > agora).all()

    return [
        {
            "id": c.id,
            "codigo": c.codigo,
            "desconto": c.desconto,
            "validade": c.validade,
            "descricao": c.descricao
        }
        for c in cupons
    ]


# ─── RESGATAR CUPOM ──────────────────────────────────────

@router.post("/resgatar")
def resgatar_cupom(usuario_id: int, cupom_id: int, db: Session = Depends(get_db)):
    # Verifica se o usuário existe
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    # Verifica se o cupom existe
    cupom = db.query(Cupom).filter(Cupom.id == cupom_id).first()
    if not cupom:
        raise HTTPException(status_code=404, detail="Cupom não encontrado")

    # Verifica se o cupom ainda é válido
    if cupom.validade < datetime.utcnow():
        raise HTTPException(status_code=400, detail="Cupom expirado")

    # Verifica se o usuário já resgatou esse cupom
    ja_resgatou = db.query(CupomUsuario).filter(
        CupomUsuario.usuario_id == usuario_id,
        CupomUsuario.cupom_id == cupom_id
    ).first()
    if ja_resgatou:
        raise HTTPException(status_code=400, detail="Cupom já resgatado")

    # Verifica se o usuário tem pontos suficientes (50 pontos por cupom)
    if usuario.pontos < 50:
        raise HTTPException(status_code=400, detail="Pontos insuficientes. Necessário 50 pontos")

    # Registra o resgate
    novo_resgate = CupomUsuario(
        usuario_id=usuario_id,
        cupom_id=cupom_id
    )
    db.add(novo_resgate)

    # Desconta os pontos
    usuario.pontos -= 50
    db.commit()

    return {
        "mensagem": "Cupom resgatado com sucesso!",
        "codigo": cupom.codigo,
        "desconto": cupom.desconto,
        "validade": cupom.validade,
        "pontos_restantes": usuario.pontos
    }


# ─── CUPONS DO USUÁRIO ───────────────────────────────────

@router.get("/meus/{usuario_id}")
def meus_cupons(usuario_id: int, db: Session = Depends(get_db)):
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    resgates = db.query(CupomUsuario).filter(
        CupomUsuario.usuario_id == usuario_id
    ).all()

    resultado = []
    for resgate in resgates:
        cupom = db.query(Cupom).filter(Cupom.id == resgate.cupom_id).first()
        resultado.append({
            "codigo": cupom.codigo,
            "desconto": cupom.desconto,
            "validade": cupom.validade,
            "descricao": cupom.descricao,
            "resgatado_em": resgate.resgatado_em
        })

    return resultado