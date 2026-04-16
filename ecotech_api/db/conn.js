// requerer a biblioteca do sequelize
const Sequelize = require('sequelize')

// requerer o dotenv para ler o arquivo .env
require('dotenv').config()

// parametros para conexao com o banco de dados
const conn = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASS,
    {
        host: process.env.DB_HOST,
        dialect: 'mysql'
    }
)

// testar a conexao
try {
    conn.authenticate()
    console.info('✅ Banco de Dados conectado com sucesso!')
} catch (error) {
    console.info(`❌ Não foi possível conectar ao banco: ${error}`)
}

module.exports = conn