// requerer o DataTypes do sequelize
const { DataTypes } = require('sequelize')
// requerer a conexao com o banco
const db = require('../db/conn')
// requerer o model Usuario para criar o relacionamento
const Usuario = require('./Usuario')

// mapear a tabela PERFIL do banco de dados
const Perfil = db.define('perfil', {
    id_perfil: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    id_usuario: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Usuario,
            key: 'id_usuario'
        }
    },
    pontos_totais: {
        type: DataTypes.INTEGER,
        defaultValue: 0
    },
    nivel: {
        type: DataTypes.STRING,
        defaultValue: 'Iniciante'
    },
    data_atualizacao: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    }
}, {
    // diz para o sequelize que a tabela já existe
    // e que ele não precisa criar nem modificar nada
    timestamps: false,
    freezeTableName: true
})

// um usuario tem um perfil
Usuario.hasOne(Perfil, { foreignKey: 'id_usuario' })
Perfil.belongsTo(Usuario, { foreignKey: 'id_usuario' })

module.exports = Perfil