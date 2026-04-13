import google.generativeai as genai
from dotenv import load_dotenv
import os
import base64

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=GEMINI_API_KEY)

model = genai.GenerativeModel("gemini-1.5-flash")


# ─── ANALISAR FOTO DO LIXO ───────────────────────────────

def analisar_lixo(imagem_bytes: bytes) -> dict:
    try:
        # Converte a imagem para base64
        imagem_base64 = base64.b64encode(imagem_bytes).decode("utf-8")

        # Prompt enviado para o Gemini
        prompt = """
        Você é um especialista em reciclagem e meio ambiente.
        Analise a imagem e responda APENAS em JSON válido, sem texto extra, nesse formato exato:

        {
            "tipo_lixo": "ex: Embalagem Plástica",
            "material": "ex: Plástico PET, derivado do petróleo",
            "motivo_descarte": "ex: Libera toxinas no solo se descartado incorretamente",
            "tempo_degradacao": "ex: Até 400 anos",
            "consequencia_incorreto": "ex: Contamina rios, solo e prejudica animais"
        }

        Responda SOMENTE o JSON, sem explicações adicionais.
        """

        # Envia a imagem e o prompt para o Gemini
        resposta = model.generate_content([
            {
                "parts": [
                    {
                        "inline_data": {
                            "mime_type": "image/jpeg",
                            "data": imagem_base64
                        }
                    },
                    {
                        "text": prompt
                    }
                ]
            }
        ])

        # Limpa a resposta e converte para dicionário
        texto = resposta.text.strip()
        texto = texto.replace("```json", "").replace("```", "").strip()

        import json
        resultado = json.loads(texto)
        return resultado

    except Exception as e:
        print(f"Erro ao analisar imagem: {e}")
        return {
            "tipo_lixo": "Não identificado",
            "material": "Não identificado",
            "motivo_descarte": "Não identificado",
            "tempo_degradacao": "Não identificado",
            "consequencia_incorreto": "Não identificado"
        }