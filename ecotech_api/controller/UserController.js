// requerer o model Usuario
const Usuario = require('../models/Usuario')
// requerer o model Perfil
const Perfil = require('../models/Perfil')
// requerer o bcrypt para criptografia
const bcrypt = require('bcrypt')

module.exports = class UserController {

    // --------------------------------------------------------
    // BUSCAR PERFIL DO USUARIO LOGADO
    // Rota: GET /usuario/:id
    // --------------------------------------------------------
    static async getPerfil(req, res) {
        const { id } = req.params

        try {
            const usuario = await Usuario.findOne({
                where: { id_usuario: id },
                // trazer o perfil junto com os dados do usuario
                include: [{
                    model: Perfil,
                    attributes: ['pontos_totais', 'nivel']
                }],
                // nao retornar a senha
                attributes: ['id_usuario', 'nome', 'email', 'status']
            })

            if (!usuario) {
                res.status(404).json({ message: "Usuário não encontrado" })
                return
            }

            res.status(200).json(usuario)

        } catch (error) {
            res.status(500).json({ message: "Erro ao buscar perfil", error: error.message })
        }
    }

    // --------------------------------------------------------
    // ALTERAR SENHA DO USUARIO LOGADO
    // Rota: PUT /usuario/alterar-senha
    // --------------------------------------------------------
    static async alterarSenha(req, res) {
        const { id_usuario, senha_atual, nova_senha } = req.body

        if (!senha_atual) {
            res.status(422).json({ message: "A senha atual é obrigatória" })
            return
        }
        if (!nova_senha) {
            res.status(422).json({ message: "A nova senha é obrigatória" })
            return
        }

        try {
            // buscar o usuario no banco
            const usuario = await Usuario.findOne({ where: { id_usuario: id_usuario } })
            if (!usuario) {
                res.status(404).json({ message: "Usuário não encontrado" })
                return
            }

            // verificar se a senha atual está correta
            const senhaCorreta = await bcrypt.compare(senha_atual, usuario.senha)
            if (!senhaCorreta) {
                res.status(422).json({ message: "Senha atual incorreta!" })
                return
            }

            // criptografar a nova senha
            const salt = await bcrypt.genSalt(12)
            const novaSenhaHash = await bcrypt.hash(nova_senha, salt)

            // atualizar a senha no banco
            await Usuario.update(
                { senha: novaSenhaHash },
                { where: { id_usuario: id_usuario } }
            )

            res.status(200).json({ message: "Senha alterada com sucesso!" })

        } catch (error) {
            res.status(500).json({ message: "Erro ao alterar senha", error: error.message })
        }
    }
}