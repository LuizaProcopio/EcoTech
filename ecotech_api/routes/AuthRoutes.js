// requerer o router do express
const router = require('express').Router()
// requerer o AuthController
const AuthController = require('../controller/AuthController')

// rota de cadastro — tela create_account.dart
router.post('/cadastro', AuthController.cadastro)

// rota de login — tela login_page.dart
router.post('/login', AuthController.login)

module.exports = router