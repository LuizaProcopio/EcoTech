from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from database import get_db
from models import Usuario, Descarte
from ia_service import analisar_lixo

router = APIRouter()


# ─── ANALISAR FOTO DO LIXO (IA) ──────────────────────────

@router.post("/analisar")
async def analisar(
    usuario_id: int,
    foto: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    # Verifica se o usuário existe
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    # Lê os bytes da imagem
    imagem_bytes = await foto.read()

    # Envia para o Gemini analisar
    resultado = analisar_lixo(imagem_bytes)

    # Registra o descarte no banco
    novo_descarte = Descarte(
        usuario_id=usuario_id,
        tipo_lixo=resultado["tipo_lixo"],
        pontos_ganhos=10
    )
    db.add(novo_descarte)

    # Soma os pontos ao usuário
    usuario.pontos += 10
    db.commit()

    # Retorna as informações do lixo + pontos ganhos
    return {
        "tipo_lixo": resultado["tipo_lixo"],
        "material": resultado["material"],
        "motivo_descarte": resultado["motivo_descarte"],
        "tempo_degradacao": resultado["tempo_degradacao"],
        "consequencia_incorreto": resultado["consequencia_incorreto"],
        "pontos_ganhos": 10,
        "total_pontos": usuario.pontos
    }


# ─── HISTÓRICO DE DESCARTES ───────────────────────────────

@router.get("/historico/{usuario_id}")
def historico(usuario_id: int, db: Session = Depends(get_db)):
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    descartes = db.query(Descarte).filter(
        Descarte.usuario_id == usuario_id
    ).order_by(Descarte.criado_em.desc()).all()

    return [
        {
            "id": d.id,
            "tipo_lixo": d.tipo_lixo,
            "pontos_ganhos": d.pontos_ganhos,
            "data": d.criado_em
        }
        for d in descartes
    ]