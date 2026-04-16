// requerer o model Usuario
const Usuario = require('../models/Usuario')
// requerer o model Perfil
const Perfil = require('../models/Perfil')
// requerer o bcrypt para criptografia
const bcrypt = require('bcrypt')
// requerer o helper de token
const createUserToken = require('../helpers/create-user-token')

module.exports = class AuthController {

    // --------------------------------------------------------
    // CADASTRO
    // Tela: create_account.dart
    // Rota: POST /auth/cadastro
    // --------------------------------------------------------
    static async cadastro(req, res) {
        const { nome, email, senha } = req.body

        // validações dos campos
        if (!nome) {
            res.status(422).json({ message: "O nome é obrigatório" })
            return
        }
        if (!email) {
            res.status(422).json({ message: "O e-mail é obrigatório" })
            return
        }
        if (!senha) {
            res.status(422).json({ message: "A senha é obrigatória" })
            return
        }

        // verificar se o email já existe no banco
        const usuarioExiste = await Usuario.findOne({ where: { email: email } })
        if (usuarioExiste) {
            res.status(422).json({ message: "E-mail já cadastrado, utilize outro e-mail" })
            return
        }

        // criptografar a senha
        const salt = await bcrypt.genSalt(12)
        const senhaHash = await bcrypt.hash(senha, salt)

        // criar o usuario no banco
        try {
            const novoUsuario = await Usuario.create({
                nome: nome,
                email: email,
                senha: senhaHash,
                status: 'ativo'
            })

            // criar o perfil do usuario automaticamente com 0 pontos
            await Perfil.create({
                id_usuario: novoUsuario.id_usuario,
                pontos_totais: 0,
                nivel: 'Iniciante'
            })

            // retornar o token para o Flutter
            await createUserToken(novoUsuario, req, res)

        } catch (error) {
            res.status(500).json({ message: "Erro ao cadastrar usuário", error: error.message })
        }
    }

    // --------------------------------------------------------
    // LOGIN
    // Tela: login_page.dart
    // Rota: POST /auth/login
    // --------------------------------------------------------
    static async login(req, res) {
        const { email, senha } = req.body

        // validações dos campos
        if (!email) {
            res.status(422).json({ message: "O e-mail é obrigatório" })
            return
        }
        if (!senha) {
            res.status(422).json({ message: "A senha é obrigatória" })
            return
        }

        // verificar se o usuario existe no banco
        const usuario = await Usuario.findOne({ where: { email: email } })
        if (!usuario) {
            res.status(422).json({ message: "Não há usuário cadastrado com este e-mail" })
            return
        }

        // verificar se o usuario está ativo
        if (usuario.status === 'inativo') {
            res.status(422).json({ message: "Usuário inativo, entre em contato com o suporte" })
            return
        }

        // verificar se a senha está correta
        const senhaCorreta = await bcrypt.compare(senha, usuario.senha)
        if (!senhaCorreta) {
            res.status(422).json({ message: "Senha inválida!" })
            return
        }

        // retornar o token para o Flutter
        await createUserToken(usuario, req, res)
    }
}