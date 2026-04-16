// requerer o jsonwebtoken
const jwt = require('jsonwebtoken')

// requerer o dotenv para ler o .env
require('dotenv').config()

const createUserToken = async (usuario, req, res) => {

    // criar o token com os dados do usuario
    const token = jwt.sign(
        {
            nome: usuario.nome,
            id: usuario.id_usuario
        },
        process.env.JWT_SECRET,
        { expiresIn: '7d' } // token válido por 7 dias
    )

    // retornar o token e os dados do usuario para o Flutter
    res.status(200).json({
        message: "Você está autenticado!",
        token: token,
        userId: usuario.id_usuario,
        userName: usuario.nome
    })
}

module.exports = createUserToken