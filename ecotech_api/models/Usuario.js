// requerer o DataTypes do sequelize
const { DataTypes } = require('sequelize')
// requerer a conexao com o banco
const db = require('../db/conn')

// mapear a tabela USUARIOS do banco de dados
const Usuario = db.define('usuarios', {
    id_usuario: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nome: {
        type: DataTypes.STRING,
        allowNull: false
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    senha: {
        type: DataTypes.STRING,
        allowNull: false
    },
    data_criacao: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    status: {
        type: DataTypes.ENUM('ativo', 'inativo'),
        defaultValue: 'ativo'
    }
}, {
    // diz para o sequelize que a tabela já existe
    // e que ele não precisa criar nem modificar nada
    timestamps: false,
    freezeTableName: true
})

module.exports = Usuario