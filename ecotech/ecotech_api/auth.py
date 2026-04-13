from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from dotenv import load_dotenv
import os

load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")
EXPIRACAO_TOKEN = 60 * 24  # 24 horas

# Configuração do bcrypt para criptografar senhas
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


# ─── SENHA ───────────────────────────────────────────────

def criptografar_senha(senha: str) -> str:
    return pwd_context.hash(senha)

def verificar_senha(senha: str, senha_hash: str) -> bool:
    return pwd_context.verify(senha, senha_hash)


# ─── TOKEN JWT ───────────────────────────────────────────

def criar_token(dados: dict) -> str:
    dados_copia = dados.copy()
    expiracao = datetime.utcnow() + timedelta(minutes=EXPIRACAO_TOKEN)
    dados_copia.update({"exp": expiracao})
    token = jwt.encode(dados_copia, SECRET_KEY, algorithm=ALGORITHM)
    return token

def verificar_token(token: str) -> dict:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        return None