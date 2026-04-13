from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Float
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime

class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    senha = Column(String(255), nullable=False)
    pontos = Column(Integer, default=0)
    criado_em = Column(DateTime, default=datetime.utcnow)

    descartes = relationship("Descarte", back_populates="usuario")
    cupons = relationship("CupomUsuario", back_populates="usuario")


class Descarte(Base):
    __tablename__ = "descartes"

    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"))
    tipo_lixo = Column(String(100))
    pontos_ganhos = Column(Integer, default=10)
    criado_em = Column(DateTime, default=datetime.utcnow)

    usuario = relationship("Usuario", back_populates="descartes")


class Cupom(Base):
    __tablename__ = "cupons"

    id = Column(Integer, primary_key=True, index=True)
    codigo = Column(String(20), unique=True)
    desconto = Column(Float)
    validade = Column(DateTime)
    descricao = Column(String(255))


class CupomUsuario(Base):
    __tablename__ = "cupons_usuarios"

    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"))
    cupom_id = Column(Integer, ForeignKey("cupons.id"))
    resgatado_em = Column(DateTime, default=datetime.utcnow)

    usuario = relationship("Usuario", back_populates="cupons")


class CodigoRecuperacao(Base):
    __tablename__ = "codigos_recuperacao"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(100), nullable=False)
    codigo = Column(String(10), nullable=False)
    criado_em = Column(DateTime, default=datetime.utcnow)