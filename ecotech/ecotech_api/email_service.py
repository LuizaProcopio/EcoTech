import smtplib
import random
import string
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from dotenv import load_dotenv
import os

load_dotenv()

EMAIL_REMETENTE = os.getenv("EMAIL_REMETENTE")
EMAIL_SENHA = os.getenv("EMAIL_SENHA")


# ─── GERAR CÓDIGO ────────────────────────────────────────

def gerar_codigo() -> str:
    # Gera um código de 7 caracteres ex: F4NK8L5
    caracteres = string.ascii_uppercase + string.digits
    return ''.join(random.choices(caracteres, k=7))


# ─── ENVIAR EMAIL ────────────────────────────────────────

def enviar_codigo_email(email_destino: str, codigo: str) -> bool:
    try:
        # Monta o email
        mensagem = MIMEMultipart("alternative")
        mensagem["Subject"] = "EcoTech - Código de recuperação de senha"
        mensagem["From"] = EMAIL_REMETENTE
        mensagem["To"] = email_destino

        # Corpo do email em HTML
        corpo_html = f"""
        <html>
            <body style="font-family: Arial, sans-serif; padding: 20px;">
                <div style="max-width: 400px; margin: auto; border: 1px solid #ddd; border-radius: 10px; padding: 30px;">
                    
                    <h2 style="color: #6A0DAD; text-align: center;">🌱 EcoTech</h2>
                    
                    <p>Olá! Recebemos uma solicitação para redefinir sua senha.</p>
                    
                    <p>Use o código abaixo no aplicativo:</p>
                    
                    <div style="background-color: #f3e8ff; border-radius: 8px; padding: 20px; text-align: center;">
                        <h1 style="color: #6A0DAD; letter-spacing: 5px;">{codigo}</h1>
                    </div>
                    
                    <p style="color: #888; font-size: 13px; margin-top: 20px;">
                        Este código expira em 15 minutos.<br>
                        Se você não solicitou isso, ignore este email.
                    </p>
                    
                </div>
            </body>
        </html>
        """

        parte_html = MIMEText(corpo_html, "html")
        mensagem.attach(parte_html)

        # Envia o email via Gmail
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as servidor:
            servidor.login(EMAIL_REMETENTE, EMAIL_SENHA)
            servidor.sendmail(EMAIL_REMETENTE, email_destino, mensagem.as_string())

        return True

    except Exception as e:
        print(f"Erro ao enviar email: {e}")
        return False