from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os

# Carrega as variáveis do .env
load_dotenv()

# Monta a URL de conexão com o MySQL
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# Cria a conexão
engine = create_engine(DATABASE_URL)

# Cria a sessão (usada nas rotas pra falar com o banco)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base usada nos models
Base = declarative_base()

# Função que abre e fecha a sessão automaticamente
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()