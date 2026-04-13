from fastapi import FastAPI
from database import engine, Base
from routes import (
    auth_routes,
    perfil_routes,
    descarte_routes,
    cupons_routes,
    ranking_routes,
    suporte_routes
)

# Cria as tabelas no banco automaticamente
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="EcoTech API",
    description="API do aplicativo EcoTech",
    version="1.0.0"
)

# Registra todas as rotas
app.include_router(auth_routes.router, prefix="/auth", tags=["Autenticação"])
app.include_router(perfil_routes.router, prefix="/perfil", tags=["Perfil"])
app.include_router(descarte_routes.router, prefix="/descarte", tags=["Descarte"])
app.include_router(cupons_routes.router, prefix="/cupons", tags=["Cupons"])
app.include_router(ranking_routes.router, prefix="/ranking", tags=["Ranking"])
app.include_router(suporte_routes.router, prefix="/suporte", tags=["Suporte"])

@app.get("/")
def raiz():
    return {"mensagem": "EcoTech API funcionando! 🌱"}