// requerer o express
const express = require('express')
// requerer o cors
const cors = require('cors')
// requerer o dotenv
require('dotenv').config()
// requerer a conexao com o banco
const db = require('./db/conn')

// requerer os models
const Usuario = require('./models/Usuario')
const Perfil = require('./models/Perfil')

// requerer as rotas
const AuthRoutes = require('./routes/AuthRoutes')
const UserRoutes = require('./routes/UserRoutes')

// instanciar o express
const api = express()

// config JSON
api.use(express.json())

// resolver o cors — permite o Flutter acessar a API
api.use(cors({ credentials: true, origin: '*' }))

// rotas
api.use('/auth', AuthRoutes)
api.use('/usuario', UserRoutes)

// rota de teste — para saber se a API está online
api.get('/', (req, res) => {
    res.status(200).json({ message: '✅ API EcoCerto está online!' })
})

// porta da API
const PORT = process.env.PORT || 3000

// sincronizar o banco e subir o servidor
db.sync()
    .then(() => {
        api.listen(PORT, () => {
            console.info(`✅ Banco de Dados conectado!`)
            console.info(`🚀 API EcoCerto rodando na porta ${PORT}`)
        })
    })
    .catch(error => {
        console.info(`❌ Erro ao conectar ao banco: ${error}`)
    })